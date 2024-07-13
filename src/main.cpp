/*
	AviUtl script DLL made by 伯林青

	:: memo ::
	using module for build
	- name              | version 
	- OpenCV + contrib  | 4.8.0
	- luajit            | 2.1.17
	- Microsoft PPL     |
	- Aviutl-plugin-sdk | 1.2
*/

#include <iostream>
#include <string>
#include <numeric>
#include <memory>
#include <tuple>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn_superres.hpp>
#include <opencv2/shape/shape_transformer.hpp>
#include <lua.hpp>
#include <windows.h>
#include <ppl.h>
#include <berl_util_module.hpp>

/********************************************************************************/
/*[function prototype]*/

int32_t superres(lua_State* L);
int32_t KmLabeling(lua_State* L);
int32_t KmPosterize(lua_State* L);
int32_t directblur(lua_State* L);
int32_t MeshReshape(lua_State* L);

cv::Mat upscaleImage(cv::Mat src, cv::String modelName, cv::String modelPath, int32_t scale);
void putting_img(cv::Mat& src, cv::Mat& dst, int32_t tx, int32_t ty);
/********************************************************************************/
/*[c++ <=> lua]*/

static luaL_Reg functions[] = {
	{"superres", superres},
	{"KmLabeling", KmLabeling},
	{"KmPosterize", KmPosterize},
	{"directblur", directblur},
	{"MeshReshape", MeshReshape},
	{ nullptr, nullptr }
};

extern "C" {
	__declspec(dllexport) int luaopen_beRLF(lua_State* L)
	{
		luaL_register(L, "beRLF", functions);
		return 1;
	}
}

/********************************************************************************/
/*[callback functions]*/

int32_t superres(lua_State* L)
{
	std::unique_ptr< AviUtl::beRL::Util> utils(new AviUtl::beRL::Util());
	const char* modelname = utils->toStringRestrict(L, 1);
	const char* modelpath = utils->toStringRestrict(L, 2);
	int32_t scale = lua_tointeger(L, 3);
	auto alphasync = static_cast<bool>(lua_toboolean(L, 4));

	if (modelname == nullptr || modelpath == nullptr)
	{
		std::cout << "cannot read model name or path" << "\n"
			<< "please enter/select correct value" << std::endl;
		return 0;
	}

	auto efp = utils->GetAddData("exedit.auf", 0x1b2b20);
	auto exdata = reinterpret_cast<ExEdit::FilterProcInfo*>(efp);
	auto dt = exdata->obj_edit;
	auto wt = exdata->obj_w;
	auto ht = exdata->obj_h;
	auto ow = exdata->obj_line;
	auto oh = exdata->obj_max_h;
	auto obj_data = exdata->obj_data;
	if ((ow < 1) || (oh < 1) || (wt < 1) || (ht < 1))
		return 0;

	cv::Mat buf(cv::Size(wt, ht), CV_8UC4);
	utils->yca2mat(&dt, buf, ow);
	if (buf.empty())
		return 0;

	// 透明度分離
	cv::Mat bgr(buf.size(), CV_8UC3), alpha(buf.size(), CV_8U);
	std::vector<cv::Mat> bgra{ bgr, alpha };
	std::vector<int32_t> ch_conf{ 0,0, 1,1, 2,2, 3,3 };
	cv::mixChannels(&buf, 1, bgra.data(), 2, ch_conf.data(), 4);
	bgra[0].copyTo(bgr);
	bgra[1].copyTo(alpha);

	try
	{	
		cv::String path(modelpath);
		cv::String model(modelname);
		auto retBGR = upscaleImage(bgr, model, path, scale);
		if ((ow-8)<retBGR.cols || oh<retBGR.rows)
		{
			std::cout << "image is too big ..." << std::endl;
		}
		
		if (alphasync)
		{
			cv::cvtColor(alpha, alpha, cv::COLOR_GRAY2BGR);
			auto retAlp = upscaleImage(alpha, model, path, scale);
			cv::cvtColor(retAlp, retAlp, cv::COLOR_BGR2GRAY);
			bgra[0] = retBGR.clone();
			bgra[1] = retAlp.clone();
			cv::Mat out(retBGR.size(), CV_8UC4);
			cv::mixChannels(bgra.data(), 2, &out, 1, ch_conf.data(), 4);
			utils->mat2yca(out, &dt, &exdata, ow);
		}
		else
		{
			cvtColor(retBGR, retBGR, cv::COLOR_BGR2BGRA);
			utils->mat2yca(retBGR, &dt, &exdata, ow);
		}
	}
	catch (cv::Exception& e)
	{
		std::cout << e.what() << std::endl;
	}
	return 0;
}

int32_t KmLabeling(lua_State* L)
{
	int32_t cluster_count = lua_tointeger(L, 1);

	std::unique_ptr< AviUtl::beRL::Util> utils(new AviUtl::beRL::Util());
	auto [frame, width, height] = utils->GetPixelData(L, "");
	cv::Mat img(cv::Size(width, height), CV_8UC4, frame), tmp;
	if (img.empty())
	{
		std::cout << "Mat array is empty..." << std::endl;
		return 0;
	}

	img.copyTo(tmp);
	cv::cvtColor(tmp, tmp, cv::COLOR_BGRA2BGR);

	cv::Mat points;
	tmp.convertTo(points, CV_32FC3);
	auto buf_size = width * height;
	points = points.reshape(3, buf_size);

	cv::Mat_<int32_t> clusters(points.size(), CV_32SC1);
	cv::Mat centers;
	cv::kmeans(
		points,
		cluster_count,
		clusters,
		cv::TermCriteria(cv::TermCriteria::EPS | cv::TermCriteria::MAX_ITER, 10, 1.0),
		1,
		cv::KMEANS_RANDOM_CENTERS,
		centers
	);

	auto itf = centers.begin<cv::Vec3f>();
	Concurrency::parallel_for(0, buf_size, 1, [&](int32_t n)
		{
			int32_t y = n / width;
			int32_t x = n % width;

			auto pOUT = img.ptr<cv::Vec4b>(y);
			auto color = itf[clusters(1, n)];

			pOUT[x][0] = cv::saturate_cast<uchar>(color[0]);
			pOUT[x][1] = cv::saturate_cast<uchar>(color[1]);
			pOUT[x][2] = cv::saturate_cast<uchar>(color[2]);
		});
	utils->PutPixelData(L, img.data);

	return 0;
}

int32_t KmPosterize(lua_State* L)
{
	int32_t cluster_count = lua_tointeger(L, 1);

	std::unique_ptr< AviUtl::beRL::Util> utils(new AviUtl::beRL::Util());
	auto [frame, width, height] = utils->GetPixelData(L, "");
	cv::Mat img(cv::Size(width, height), CV_8UC4, frame), tmp;
	if (img.empty())
	{
		std::cout << "Mat array is empty..." << std::endl;
		return 0;
	}

	img.copyTo(tmp);
	cv::cvtColor(tmp, tmp, cv::COLOR_BGRA2BGR);

	cv::Mat points;
	tmp.convertTo(points, CV_32FC3);
	auto buf_size = width * height;
	points = points.reshape(3, buf_size);

	cv::Mat_<int32_t> clusters(points.size(), CV_32SC1);
	cv::Mat centers;
	cv::kmeans(
		points,
		cluster_count,
		clusters,
		cv::TermCriteria(cv::TermCriteria::EPS | cv::TermCriteria::MAX_ITER, 10, 1.0),
		1,
		cv::KMEANS_PP_CENTERS,
		centers
	);

	Concurrency::parallel_for(0, buf_size, 1, [&](int32_t n)
		{
			int32_t y = n / width;
			int32_t x = n % width;

			auto pOUT = img.ptr<cv::Vec4b>(y);
			auto color = centers.ptr<cv::Vec3f>(clusters(n));

			pOUT[x][0] = cv::saturate_cast<uchar>(color[0][0]);
			pOUT[x][1] = cv::saturate_cast<uchar>(color[0][1]);
			pOUT[x][2] = cv::saturate_cast<uchar>(color[0][2]);
		});

	utils->PutPixelData(L, img.data);
	return 0;
}

int32_t directblur(lua_State* L)
{
	double degree = lua_tonumber(L, 1);
	int32_t ksize = lua_tointeger(L, 2);
	double sigma = lua_tonumber(L, 3);

	std::unique_ptr< AviUtl::beRL::Util> utils(new AviUtl::beRL::Util());
	auto [frame, width, height] = utils->GetPixelData(L, "");
	cv::Mat img(cv::Size(width, height), CV_8UC4, frame), tmp;
	if (img.empty())
	{
		std::cout << "Mat array is empty..." << std::endl;
		return 0;
	}
	img.copyTo(tmp);

	double rx = std::cos(degree * CV_PI / 180);
	double ry = std::sin(degree * CV_PI / 180);
	std::vector<float> kl(ksize * ksize, 0.0);
	Concurrency::parallel_for(0, ksize, 1, [ksize, rx, ry, &kl, sigma](int j)
		{
			for (int i = 0; i < ksize; i++)
			{
				float x = static_cast<float>(i - ksize / 2);
				float y = static_cast<float>(j - ksize / 2);
				float elements = static_cast<float>(std::exp(-1 * (x * ry - y * rx) * (x * ry - y * rx) / (2 * sigma)));
				kl[i + j * ksize] = elements;
			}
		}
	);
	cv::Mat kernel(cv::Size(ksize, ksize), CV_32F, kl.data());
	float sums = std::reduce(kl.begin(), kl.end());
	kernel = kernel / sums;
	cv::Mat result;
	cv::filter2D(tmp, result, -1, kernel);

	utils->PutPixelData(L, result.data);
	return 0;
}

int32_t MeshReshape(lua_State* L)
{
	try
	{
		int32_t shepemethod = std::clamp(lua_tointeger(L, 1), 0, 6);
		int32_t margin = max(lua_tointeger(L, 2), 0);

		std::unique_ptr<AviUtl::beRL::Util> utils(new AviUtl::beRL::Util());
		auto efp = utils->GetAddData("exedit.auf", 0x1b2b20);
		auto exdata = reinterpret_cast<ExEdit::FilterProcInfo*>(efp);
		auto dt = exdata->obj_edit;
		auto wt = exdata->obj_w;
		auto ht = exdata->obj_h;
		auto ow = exdata->obj_line;
		auto oh = exdata->obj_max_h;
		auto obj_data = exdata->obj_data;
		if ((ow < 1) || (oh < 1) || (wt < 1) || (ht < 1))
			return 0;

		cv::Mat buf(cv::Size(wt, ht), CV_8UC4);
		utils->yca2mat(&dt, buf, ow);
		if (buf.empty())
			return 0;

		// 制御点の取得（変形後）
		std::vector<std::vector<double>> afpt = utils->GetLuaTableNum(L, "keypoint");
		std::vector<cv::Point2i> aft_ctrlpoint;
		int32_t min_x = 0;
		int32_t min_y = 0;
		int32_t max_x = 0;
		int32_t max_y = 0;
		for (auto i = 0; i < afpt[0][0]; ++i)
		{
			cv::Point2i ctrlp(0, 0);
			ctrlp.x = afpt[1][2 * i];
			ctrlp.y = afpt[1][2 * i + 1];
			aft_ctrlpoint.emplace_back(ctrlp);

			if (ctrlp.x < min_x)
			{
				min_x = ctrlp.x;
			}

			if (ctrlp.y < min_y)
			{
				min_y = ctrlp.y;
			}

			if (ctrlp.x > max_x)
			{
				max_x = ctrlp.x;
			}

			if (ctrlp.y > max_y)
			{
				max_y = ctrlp.y;
			}
		}

		// 制御点の取得（変形前）
		int32_t new_w = max_x - min_x + margin;
		int32_t new_h = max_y - min_y + margin;
		new_w = (new_w > wt) ? new_w : wt;
		new_h = (new_h > ht) ? new_h : ht;
		int32_t tx = (new_w - wt) / 2;
		int32_t ty = (new_h - ht) / 2;
		std::vector<cv::Point2i> bfr_ctrlpoint;
		for (auto j = 0; j < 4; ++j)
		{
			for (auto i = 0; i < 4; ++i)
			{
				int idx = i + j * 4;
				bfr_ctrlpoint.emplace_back(cv::Point2i(tx + i * wt / 3.0, ty + j * ht / 3.0));
			}
		}

		// 制御点の調整
		bfr_ctrlpoint.emplace_back(cv::Point2i(0, 0));
		bfr_ctrlpoint.emplace_back(cv::Point2i(new_w - 1, 0));
		bfr_ctrlpoint.emplace_back(cv::Point2i(0, new_h - 1));
		bfr_ctrlpoint.emplace_back(cv::Point2i(new_w - 1, new_h - 1));

		for (auto i = 0; i < afpt[0][0]; ++i)
		{
			aft_ctrlpoint[i].x += new_w / 2;
			aft_ctrlpoint[i].y += new_h / 2;
		}
		aft_ctrlpoint.emplace_back(cv::Point2i(0, 0));
		aft_ctrlpoint.emplace_back(cv::Point2i(new_w - 1, 0));
		aft_ctrlpoint.emplace_back(cv::Point2i(0, new_h - 1));
		aft_ctrlpoint.emplace_back(cv::Point2i(new_w - 1, new_h - 1));

		// バッファに余白を持たせることで変形全体を表示させる
		cv::Mat buffer_max = cv::Mat::zeros(cv::Size(new_w, new_h), CV_8UC4);
		if (new_w == wt && new_h == ht)
			buffer_max = buf.clone();
		else
			putting_img(buf, buffer_max, tx, ty);

		// Thin plate splineの実行
		std::vector<cv::DMatch> matches;
		for (int32_t i = 0; i < aft_ctrlpoint.size(); ++i)
			matches.push_back(cv::DMatch(i, i, 0));
		auto tps = cv::createThinPlateSplineShapeTransformer();
		tps->estimateTransformation(aft_ctrlpoint, bfr_ctrlpoint, matches);

		// 画像を変形
		std::vector<int32_t> rsmode{
			cv::INTER_NEAREST,
			cv::INTER_LINEAR,
			cv::INTER_CUBIC,
			cv::INTER_AREA,
			cv::INTER_LANCZOS4,
			cv::INTER_LINEAR_EXACT,
			cv::INTER_NEAREST_EXACT
		};
		cv::Mat dst;
		tps->warpImage(buffer_max, dst, rsmode[shepemethod]);

		// 出力
		utils->mat2yca(dst, &dt, &exdata, ow);
	}
	catch (const std::exception& ex)
	{
		std::cout << ex.what() << std::endl;
	}

	return 0;
}

/********************************************************************************/
/*[utility functions]*/

cv::Mat upscaleImage(cv::Mat src, cv::String modelName, cv::String modelPath, int32_t scale) {
	cv::dnn_superres::DnnSuperResImpl sr;
	cv::Mat dst;

	sr.readModel(modelPath);
	sr.setModel(modelName, scale);

	sr.upsample(src, dst);
	return dst;
}

void putting_img(cv::Mat& src, cv::Mat& dst, int32_t tx, int32_t ty)
{
	//前景画像の変形行列
	cv::Mat mat = (cv::Mat_<double>(2, 3) << 1.0, 0.0, tx, 0.0, 1.0, ty);

	//アフィン変換の実行
	cv::warpAffine(src, dst, mat, dst.size(), cv::INTER_LINEAR, cv::BORDER_TRANSPARENT);
}