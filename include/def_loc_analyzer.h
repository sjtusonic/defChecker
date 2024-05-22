#ifndef DEF_LOC_ANALYZER_H
#define DEF_LOC_ANALYZER_H

#include <iostream>
#include <stdio.h>
#include <fstream>
#include <sstream>
#include <vector>
#include <map>
#include <assert.h>
using namespace std;
class Point {
	public:
	Point(int u,int v){
		x=u;y=v;
	}
	~Point(){
	}
	private:
	int x;
	int y;
} ;
class Segment {
	public:
	Segment(int u,int v){
		_start=u;_end=v;
	}
	~Segment(){
	}
	bool within (Segment& other) {
		if (_type==other._type) {
			if(_start>other._start && _end<other._end) {
				return true;
			}
		}
		return false;
	}
	bool touch (Segment& other) {
		if (_type==other._type) {
			if(
				_start==other._start || _end==other._end ||
				_start==other._start || _end==other._end
				) {
				return true;
			}
		}
		return false;
	}
	bool intersect (Segment& other) {
		if (_type!=other._type) {
			return false;
		}
			if(_start<other._start || _end>other._end) {
				return false;
			}
		return true;
	}
	// bool within (Segment& other) {
	// 	if (_type==other._type) {
	// 		if(_start>other._start && _end<other._end) {
	// 			return true;
	// 		}
	// 	}
	// 	return false;
	// }
	private:
	int _start;
	int _end;
	int _type;
} ;
class Box  {
	public:
	Box (){
	}
	Box (int u,int v,int w,int t){
		llx=u;
		lly=v;
		urx=w;
		ury=t;
	}
	void setLoc (int u,int v) {llx=u;lly=v;}
	float getArea(
		std::map<string,float> &map) {
		return (urx-llx)*(ury-lly);
		}
	~Box (){
	}
	// bool within (Segment& other) {
	// 	if (_type==other._type) {
	// 		if(_start>other._start && _end<other._end) {
	// 			return true;
	// 		}
	// 	}
	// 	return false;
	// }
	int llx;
	int lly;
	int urx;
	int ury;
	private:
} ;
class Component:public Box {
	public:
	Component(int u,int v,string refName) {
		int urx=1;
		int ury=1;
		Box(u,v,urx,ury);
	}
	~Component(){
	}
	string _refName;
	private:
} ;
class Row:public Box {
	public:
	Row(int u,int v){
		x=u;y=v;
	}
	~Row(){
	}
	private:
	int x;
	int y;
} ;
// ----------------
class LefTable {
	public:
	LefTable(){
		string fname="data/widthHeight.csv";
		ifstream file(fname);
		if(!file.is_open()) {
			cout<<"file not open:"<<fname<<""<<endl;
			return ;
		}
		string line;

		while(getline(file,line)) {
			stringstream ss(line);
			vector<string> row;
			string data;

			while(getline(ss,data,',')){
				row.push_back(data);
			}
			assert(row.size()==3);
			float w=stof(row[1]);
			float h=stof(row[2]);
			float area=w*h;
			Point p(w,h);
			_mapLibCel2WidthHeight[row[0]]=p;
			_mapLibCel2Area[row[0]]=stof(area);
		}
	}
	void GetTableArea(
		std::map<string,float> &out) {
		out=_mapLibCel2Area;
	}
	void GetTableWidthHeight(
		std::map<string,Point> &out) {
		out=_mapLibCel2WidthHeight;
	}
	~LefTable(){
	}
		std::map<string,float> _mapLibCel2Area;
		std::map<string,Point> _mapLibCel2WidthHeight;

	private:
} ;
#endif 
