#include <mmeapi.h>
#include <windows.h>
#include <ppl.h>

#include <string>
#include <vector>
#include <any>
#include <bit>
#include <type_traits>
#include <aviutl.hpp>
#include <exedit.hpp>
#include <lua.hpp>
#include <opencv2/opencv.hpp>

namespace AviUtl {
	namespace beRL {
		class Util
		{
		private:

		public:
			Util();
			~Util();

			// グローバルテーブル読み取り（数値のみ）
			void SearchTableNum(lua_State* L, int32_t stackIndex, std::vector<std::vector<double>>& dst, int key);
			std::vector<std::vector<double>> GetLuaTableNum(lua_State* L, const char* valname, int32_t stack_margin);

			// グローバルテーブル読み取り（すべて）
			void SearchTableAny(lua_State* L, int32_t stackIndex, std::vector<std::vector<std::any>>& dst, int key);
			std::vector<std::vector<std::any>> GetLuaTableAny(lua_State* L, const char* valname, int32_t stack_margin);

			// 文字列読み取り
			const char* toStringRestrict(lua_State* L, int idx) noexcept;

			// 内部データ読み取り
			uintptr_t GetAddData(const char* modname, uintptr_t address);

			// バッファ読み書き（Aviutl関数）
			std::tuple<void*, int32_t, int32_t> GetPixelData(lua_State* L, const char* mode);
			void PutPixelData(lua_State* L, void* pixeldata);

			// バッファ読み書き（内部データ）
			void yca2mat(ExEdit::PixelYCA** src, cv::Mat& dst, int32_t stride);
			void mat2yca(cv::Mat src, ExEdit::PixelYCA** dst, ExEdit::FilterProcInfo** exdata, int32_t stride);
		};
	

		Util::Util()
		{
		}

		Util::~Util()
		{
		}

		void Util::SearchTableNum
		(lua_State* L, int32_t stackIndex, std::vector<std::vector<double>>& dst, int32_t key)
		{
			std::vector<double> elements;
			int32_t stackHead = lua_gettop(L);
			lua_pushnil(L);
			while (lua_next(L, stackHead) != 0)
			{
				if (lua_istable(L, -1))
				{
					dst.emplace_back(elements);
					this->SearchTableNum(L, lua_gettop(L), dst, key+1);
				}
				else
				{
					if (lua_isnumber(L, -1))
					{
						double ele = lua_tonumber(L, -1);
						dst[key].emplace_back(ele);
					}
				}
				lua_pop(L, 1);
			}
		}

		std::vector<std::vector<double>> Util::GetLuaTableNum
		(lua_State* L, const char* valname, int32_t stack_margin=100)
		{
			std::vector<std::vector<double>> vals;
			luaL_openlibs(L);
			lua_getglobal(L, valname);

			if (lua_checkstack(L, stack_margin) == 0)
				return vals;

			std::vector<double> init;
			vals.emplace_back(init);
			this->SearchTableNum(L, lua_gettop(L), vals, 0);
			return vals;
		}

		void Util::SearchTableAny
		(lua_State* L, int32_t stackIndex, std::vector<std::vector<std::any>>& dst, int32_t key)
		{
			std::vector<std::any> elements;
			int32_t stackHead = lua_gettop(L);
			lua_pushnil(L);
			while (lua_next(L, stackHead) != 0)
			{
				if (lua_istable(L, -1))
				{
					dst.emplace_back(elements);
					this->SearchTableAny(L, lua_gettop(L), dst, key + 1);
				}
				else
				{
					std::any ele = nullptr;
					bool flags = false;
					switch (lua_type(L, -1))
					{
					case LUA_TBOOLEAN:
						ele = static_cast<bool>(lua_toboolean(L, -1));
						flags = true;
						break;
					case LUA_TNUMBER:
						ele = lua_tonumber(L, -1);
						flags = true;
						break;
					case LUA_TSTRING:
						ele = toStringRestrict(L, -1);
						flags = (typeid(ele) == typeid(const char*));
						break;
					case LUA_TLIGHTUSERDATA:
						ele = lua_touserdata(L, -1);
						flags = true;
						break;
					case LUA_TUSERDATA:
						ele = lua_topointer(L, -1);
						flags = true;
						break;
					default:
						flags = false;
						break;
					}

					if (flags)
						dst[key].emplace_back(ele);
				}
				lua_pop(L, 1);
			}
		}

		std::vector<std::vector<std::any>> Util::GetLuaTableAny
		(lua_State* L, const char* valname, int32_t stack_margin=100)
		{
			std::vector<std::vector<std::any>> vals;
			luaL_openlibs(L);
			lua_getglobal(L, valname);

			if (lua_checkstack(L, stack_margin) == 0)
				return vals;

			std::vector<std::any> init;
			vals.emplace_back(init);
			this->SearchTableAny(L, lua_gettop(L), vals, 0);
			return vals;
		}

		const char* Util::toStringRestrict
		(lua_State* L, int idx) noexcept
		{
			if (lua_isnumber(L, idx))
			{
				double num = lua_tonumber(L, idx);
				std::string tmp = std::to_string(num);
				const char* chr = tmp.c_str();
				return chr;
			}
			else if (lua_isstring(L, idx))
			{
				return lua_tostring(L, idx);
			}
			else
			{
				return nullptr;
			}
		}

		uintptr_t Util::GetAddData
		(const char* modname, uintptr_t address)
		{
			HMODULE hmod = GetModuleHandleA(modname);
			uint32_t& base_add = (uint32_t&)hmod;
			uint32_t dp = *std::bit_cast<std::add_pointer_t<uint32_t>>(base_add + address);

			DWORD old = 0;
			auto pt = reinterpret_cast<LPVOID>(dp);
			VirtualProtect(pt, sizeof(pt), PAGE_EXECUTE_READWRITE, &old);

			return dp;
		}

		std::tuple<void*, int32_t, int32_t> Util::GetPixelData
		(lua_State* L, const char* mode)
		{
			lua_getglobal(L, "obj");
			lua_getfield(L, -1, "getpixeldata");
			lua_pushstring(L, mode);  // ここから引数
			lua_call(L, 1, 3);

			void* frame = lua_touserdata(L, -3);
			int32_t width = lua_tointeger(L, -2);
			int32_t height = lua_tointeger(L, -1);

			lua_pop(L, 3);  // スタックから消去

			return { frame, width, height };
		}

		void Util::PutPixelData
		(lua_State* L, void* buffer)
		{
			lua_getglobal(L, "obj");
			lua_getfield(L, -1, "putpixeldata");
			lua_pushlightuserdata(L, buffer);
			lua_call(L, 1, 0);
			lua_pop(L, 1);
		}

		void Util::yca2mat
		(ExEdit::PixelYCA** src, cv::Mat& dst, int32_t stride)
		{
			if (dst.rows < 1 || dst.cols < 1)
				return;

			Concurrency::parallel_for(0, dst.rows, 1, [&](int32_t y)
				{
					auto pBGRA = dst.ptr<cv::Vec4b>(y);

					for (auto x = 0; x < dst.cols; ++x)
					{
						int32_t idx = x + y * stride;

						int32_t uy = static_cast<int32_t>((*src + idx)->y);
						int32_t ucb = static_cast<int32_t>((*src + idx)->cb);
						int32_t ucr = static_cast<int32_t>((*src + idx)->cr);
						int32_t ua = static_cast<int32_t>((*src + idx)->a);

						pBGRA[x][0] = cv::saturate_cast<uint8_t>((3 + ((uy * 16320) >> 16) + ((ucb * 28919) >> 16)) >> 2);
						pBGRA[x][1] = cv::saturate_cast<uint8_t>((3 + ((uy * 16320) >> 16) + ((ucb * -5616) >> 16) + ((ucr * -11655) >> 16)) >> 2);
						pBGRA[x][2] = cv::saturate_cast<uint8_t>((3 + ((uy * 16320) >> 16) + ((ucr * 22881) >> 16)) >> 2);
						pBGRA[x][3] = cv::saturate_cast<uint8_t>((3 + ((ua * 16320) >> 16)) >> 2);
					}
				}
			);
		}

		void Util::mat2yca
		(cv::Mat src, ExEdit::PixelYCA** dst, ExEdit::FilterProcInfo** exdata, int32_t stride)
		{
			if (src.rows < 1 || src.cols < 1)
				return;
			Concurrency::parallel_for(0, src.rows, 1, [&](int32_t y)
				{
					auto pSRC = src.ptr<cv::Vec4b>(y);

					for (auto x = 0; x < src.cols; ++x)
					{
						int32_t idx = x + y * stride;
						int32_t r = static_cast<int32_t>(pSRC[x][2]);
						int32_t g = static_cast<int32_t>(pSRC[x][1]);
						int32_t b = static_cast<int32_t>(pSRC[x][0]);
						int32_t a = static_cast<int32_t>(pSRC[x][3]);

						int32_t r_ = (r << 6) + 18;
						int32_t g_ = (g << 6) + 18;
						int32_t b_ = (b << 6) + 18;
						int32_t a_ = (a << 6) + 1;

						(*dst + idx)->y = static_cast<int16_t>(((r_ * 4918) >> 16) + ((g_ * 9655) >> 16) + ((b_ * 1875) >> 16) - 3);
						(*dst + idx)->cb = static_cast<int16_t>(((r_ * -2775) >> 16) + ((g_ * -5449) >> 16) + ((b_ * 8224) >> 16) + 1);
						(*dst + idx)->cr = static_cast<int16_t>(((r_ * 8224) >> 16) + ((g_ * -6887) >> 16) + ((b_ * -1337) >> 16) + 1);
						(*dst + idx)->a = static_cast<int16_t>((a_ * 16448) >> 16);
					}
				}
			);
			(*exdata)->obj_w = src.cols;
			(*exdata)->obj_h = src.rows;
		}
	}
}