// #include "def_loc_analyzer.h"
#include <iostream>
#include <stdio.h>
#include <fstream>
#include <sstream>
#include <vector>
#include <map>
#include <assert.h>
using namespace std;
float parseSumFile (string fileName, 
		vector<Row>& rows,
		vector<Component*>& cells
		) {
	ifstream file(fileName);
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
		if (row[0]=="DIEAREA") {
			int widthDie=row[3];
			int heightDie=row[4];
			float areaDie=widthDie*heightDie;
		} else if (row[0]=="ROW") {
		} else if (row[0]=="COMP") {
			Component c=new Component();
			cells.push_back(c);
		}
	}
	return areaDie;
}
int main() {
	LefTable at;
	Box box;
	box.setLoc(1,2);

	map<string,Point> table;
	at.GetTableWidthHeight(table);
	box._refName="AND2";
	float area=box.getArea(table);
	cout<<"area="<<area<<""<<endl;
	parseSumFile("./data/simple07.def.sum");
	return 0;
}
