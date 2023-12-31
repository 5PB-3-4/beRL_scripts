/*
	AviUtl script DLL made by 伯林青

	:: memo ::
	using module for build
	- OpenCV + contrib 4.8.0
	- luajit 2.1.17
	- Microsoft PPL
*/

#include <iostream>
#include <string>
#include <numeric>
#include <opencv2/opencv.hpp>
#include <opencv2/dnn_superres.hpp>
#include <lua.hpp>
#include <windows.h>
#include <ppl.h>

using namespace cv;
using namespace dnn;
using namespace dnn_superres;
using namespace Concurrency;

/********************************************************************************/
/*[function prototype]*/

int superres(lua_State* L);
int KmLabeling(lua_State* L);
int KmPosterize(lua_State* L);
int directblur(lua_State* L);

const char* toStringRestrict(lua_State* L, int idx) noexcept;
Mat upscaleImage(Mat img, cv::String model, cv::String modelPath, int scale);
/********************************************************************************/
/*[c++ <=> lua]*/

static luaL_Reg functions[] = {
	{"superres", superres},
	{"KmLabeling", KmLabeling},
	{"KmPosterize", KmPosterize},
	{"directblur", directblur},
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

int superres(lua_State* L) {
	void* output = lua_touserdata(L, 1);
	int width = static_cast<int>(lua_tointeger(L, 2));
	int height = static_cast<int>(lua_tointeger(L, 3));
	void* input = lua_touserdata(L, 4);
	int Stop = static_cast<int>(lua_tointeger(L, 5));
	int Slft = static_cast<int>(lua_tointeger(L, 6));
	const char* modelname = toStringRestrict(L, 7);
	const char* modelpath = toStringRestrict(L, 8);
	int scale = static_cast<int>(lua_tointeger(L, 9));
	bool alphasync = static_cast<bool>(lua_toboolean(L, 10));

	if (modelname == nullptr || modelpath == nullptr)
	{
		std::cout << "cannot read model name or path" << "\n"
			<< "please enter/select correct value" << std::endl;
		return 0;
	}

	Mat out(height, width, CV_8UC4, output);
	Mat in(height / scale, width / scale, CV_8UC4, input);
	if (out.empty() || in.empty())
	{
		std::cout << "Mat array is empty..." << std::endl;
		return 0;
	}

	// 領域拡張前の画像領域取得と透明度分離
	Mat roi, cpRoi, chAlpha, rgbRoi;
	std::vector<Mat> chi;  // 分離した色チャンネル

	// 分離
	cv::split(in, chi);
	chAlpha = chi[3].clone();
	cvtColor(in, rgbRoi, COLOR_BGRA2BGR);
	cvtColor(chAlpha, chAlpha, COLOR_GRAY2BGR);
	chi.clear();

	try
	{
		cv::String path(modelpath);
		cv::String model(modelname);

		Mat retRGB = upscaleImage(rgbRoi, model, path, scale);
		if (!alphasync)
		{
			cvtColor(retRGB, retRGB, COLOR_BGR2BGRA);
			memcpy(output, retRGB.data, width * height * retRGB.channels());
		}
		else
		{
			Mat retAlp = upscaleImage(chAlpha, model, path, scale);
			cvtColor(retAlp, retAlp, COLOR_BGR2GRAY);
			parallel_for(0, out.rows, 1, [&out, &retRGB, &retAlp](int y)
				{
					auto pout = out.ptr<Vec4b>(y);
					auto prgb = retRGB.ptr<Vec3b>(y);
					auto palp = retAlp.ptr<uchar>(y);

					for (auto i = 0; i < out.cols; ++i)
					{
						pout[i][0] = prgb[i][0];
						pout[i][1] = prgb[i][1];
						pout[i][2] = prgb[i][2];
						pout[i][3] = palp[i];
					}
				}
			);
		}
	}
	catch (cv::Exception& e)
	{
		std::cout << e.what() << std::endl;
	}
	return 0;
}

int KmLabeling(lua_State* L)
{
	void* udata = lua_touserdata(L, 1);
	int w = static_cast<int>(lua_tointeger(L, 2));
	int h = static_cast<int>(lua_tointeger(L, 3));
	int clusterN = static_cast<int>(lua_tointeger(L, 4));

	Mat img(h, w, CV_8UC4, udata), tmp;
	if (img.empty())
	{
		std::cout << "Mat array is empty..." << std::endl;
		return 0;
	}

	img.copyTo(tmp);
	cvtColor(tmp, tmp, COLOR_BGRA2BGR);

	Mat points;
	tmp.convertTo(points, CV_32FC3);
	points = points.reshape(3, tmp.rows * tmp.cols);

	Mat_<int> clusters(points.size(), CV_32SC1);
	Mat centers;
	kmeans(
		points,
		clusterN,
		clusters,
		TermCriteria(TermCriteria::EPS | TermCriteria::MAX_ITER, 10, 1.0),
		1,
		KMEANS_RANDOM_CENTERS,
		centers
	);

	auto itf = centers.begin<Vec3f>();
	parallel_for(0, img.rows * img.cols, 1, [&img, &clusters, itf](int n)
		{
			int y = n / img.cols;
			int x = n % img.cols;

			auto pout = img.ptr<Vec4b>(y);
			Vec3f color = itf[clusters(1, n)];

			pout[x][0] = saturate_cast<uchar>(color[0]);
			pout[x][1] = saturate_cast<uchar>(color[1]);
			pout[x][2] = saturate_cast<uchar>(color[2]);
		});

	return 0;
}

int KmPosterize(lua_State* L)
{
	void* udata = lua_touserdata(L, 1);
	int w = static_cast<int>(lua_tointeger(L, 2));
	int h = static_cast<int>(lua_tointeger(L, 3));
	int cluster_count = static_cast<int>(lua_tointeger(L, 4));

	Mat img(h, w, CV_8UC4, udata), src_img;
	if (img.empty())
	{
		std::cout << "Mat array is empty..." << std::endl;
		return 0;
	}

	img.copyTo(src_img);
	cvtColor(src_img, src_img, COLOR_BGRA2BGR);

	Mat points;
	src_img.convertTo(points, CV_32FC3);
	points = points.reshape(3, src_img.rows * src_img.cols);

	cv::Mat_<int> clusters(points.size(), CV_32SC1);
	cv::Mat centers;

	cv::kmeans(
		points,
		cluster_count,
		clusters,
		TermCriteria(TermCriteria::EPS | TermCriteria::MAX_ITER, 10, 1.0),
		1,
		KMEANS_PP_CENTERS,
		centers
	);

	parallel_for(0, img.rows * img.cols, 1, [&img, &clusters, &centers](int n)
		{
			int y = n / img.cols;
			int x = n % img.cols;

			auto pout = img.ptr<Vec4b>(y);
			auto color = centers.ptr<Vec3f>(clusters(n));

			pout[x][0] = saturate_cast<uchar>(color[0][0]);
			pout[x][1] = saturate_cast<uchar>(color[0][1]);
			pout[x][2] = saturate_cast<uchar>(color[0][2]);
		});

	return 0;
}

int directblur(lua_State* L)
{
	auto pFrame = lua_touserdata(L, 1);
	auto width = static_cast<int>(lua_tointeger(L, 2));
	auto height = static_cast<int>(lua_tointeger(L, 3));
	auto degree = static_cast<double>(lua_tonumber(L, 4));
	auto ksize = static_cast<int>(lua_tointeger(L, 5));
	auto sigma = static_cast<double>(lua_tonumber(L, 6));

	Mat img(height, width, CV_8UC4, pFrame), tmp;
	if (img.empty())
	{
		std::cout << "Mat array is empty..." << std::endl;
		return 0;
	}
	img.copyTo(tmp);

	double rx = std::cos(degree * CV_PI / 180);
	double ry = std::sin(degree * CV_PI / 180);
	std::vector<float> kl(ksize * ksize, 0.0);
	parallel_for(0, ksize, 1, [ksize, rx, ry, &kl, sigma](int j)
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
	Mat kernel(ksize, ksize, CV_32F, kl.data());
	float sums = std::reduce(kl.begin(), kl.end());
	kernel = kernel / sums;
	Mat result;
	cv::filter2D(tmp, result, -1, kernel);

	memcpy(pFrame, result.data, width * height * tmp.channels());
	return 0;
}
/********************************************************************************/
/*[utility functions]*/

const char* toStringRestrict(lua_State* L, int idx) noexcept {
	if (lua_type(L, idx) != LUA_TSTRING) return nullptr;
	return lua_tostring(L, idx);
}

Mat upscaleImage(Mat img, cv::String model, cv::String modelPath, int scale) {
	DnnSuperResImpl sr;
	Mat image_output;

	sr.readModel(modelPath);
	sr.setModel(model, scale);

	sr.upsample(img, image_output);
	return image_output;
}
