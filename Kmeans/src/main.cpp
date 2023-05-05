/*
	AviUtl script DLL made by 伯林青

	:: memo ::
	using module for build
	・OpenCV 4.7.0
	・lua 5.1.4
	・Microsoft PPL

*/

#include <iostream>
#include <numeric>

#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
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

int superres(lua_State *L);
int KmLabeling(lua_State* L);
int KmPosterize(lua_State* L);

const char* toStringRestrict(lua_State* L, int idx) noexcept;
Mat upscaleImage(Mat img, cv::String model, cv::String modelPath, int scale);
/********************************************************************************/
/*[c++ <=> lua]*/

static luaL_Reg functions[] = {
	{"superres", superres},
	{"KmLabeling", KmLabeling},
	{"KmPosterize", KmPosterize},
	{ nullptr, nullptr }
};

extern "C" {
	__declspec(dllexport) int luaopen_beRLF(lua_State* L) {
		luaL_register(L, "beRLF", functions);
		return 1;
	}
}

/********************************************************************************/
/*[callback functions]*/

int superres(lua_State *L) {
	void* udata = lua_touserdata(L, 1);
	int width = static_cast<int>(lua_tointeger(L, 2));
	int height = static_cast<int>(lua_tointeger(L, 3));

	int Stop = static_cast<int>(lua_tointeger(L, 4));
	int Slft = static_cast<int>(lua_tointeger(L, 5));

	const char* modelname = toStringRestrict(L, 6);
	const char* modelpath = toStringRestrict(L, 7);
	int scale = static_cast<int>(lua_tointeger(L, 8));

	if (modelname == nullptr || modelpath == nullptr)
	{
		std::cout << "cannot read model name or path" << "\n"
			<< "please enter/select correct value" << std::endl;
		return 0;
	}

	Mat img(height, width, CV_8UC4, udata);
	if (img.empty())
	{
		std::cout << "Mat array is empty..." << std::endl;
		return 0;
	}

	Mat cpyi, roii, roiup;
	img.copyTo(cpyi);
	cvtColor(cpyi, cpyi, COLOR_BGRA2BGR);

	try
	{
		roii = cpyi(cv::Rect(Slft, Stop, width / scale, height / scale));
		roii.copyTo(roiup);

		cv::String path(modelpath);
		cv::String model(modelname);
		
		Mat result = upscaleImage(roiup, model, path, scale);

		parallel_for(0, img.rows, 1, [&img, &result](int y)
		{
			auto pout = img.ptr<Vec4b>(y);
			auto ptr = result.ptr<Vec3b>(y);
			for (auto i = 0; i < img.cols; ++i)
			{
				pout[i][0] = ptr[i][0];
				pout[i][1] = ptr[i][1];
				pout[i][2] = ptr[i][2];
				pout[i][3] = 255;
			}
		});
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
	points = points.reshape(3, src_img.rows*src_img.cols);

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
	return (image_output);
}

/********************************************************************************/
/*[reference]*/
/*
	・超解像
	https://qiita.com/gomamitu/items/b4722741f6318d734bce

	・Kmeans法
	http://opencv.jp/cookbook/opencv_img.html#k-means
	http://opencv.jp/opencv2-x-samples/k-means_clustering/
*/