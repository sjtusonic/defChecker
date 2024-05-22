DIR_INC = ./include
DIR_SRC = ./src
DIR_OBJ = ./obj
DIR_BIN = ./bin

SRC = $(wildcard ${DIR_SRC}/*.cpp)  
OBJ = $(patsubst %.cpp,${DIR_OBJ}/%.o,$(notdir ${SRC})) 

TARGET = main

BIN_TARGET = ${DIR_BIN}/${TARGET}

CC = g++ 
#CC = g++ -E
#CC = clang
CFLAGS = -v -g -Wall -I${DIR_INC}
#CFLAGS = -v -g -I${DIR_INC}

${BIN_TARGET}:${OBJ}
	# make ctags
	$(CC) $(OBJ)  -o $@ 
	#-$(CC) $(OBJ)  -o $@ 2> link.log
	#-cat link.log
	@echo "=========================================================================================="

${DIR_OBJ}/%.o:${DIR_SRC}/%.cpp
	$(CC) $(CFLAGS) -c  $< -o $@  
	#$(CC) $(CFLAGS) -c  $< -o $@ 2> compile.log
	#cat compile.log
	@echo "=========================================================================================="
.PHONY:clean run
clean:
	#find ${DIR_OBJ} -name *.o -exec rm -rf {}
	rm ${DIR_OBJ}/*.o
	rm ${DIR_BIN}/*.exe
run:
	${BIN_TARGET}
debug:
	gdb -tui -f ${BIN_TARGET}
ctags:
	ctags -R --sort=yes --c++-kinds=+px --fields=+iaS --extra=+q
ctags_system:
	ctags -R --sort=yes -I __THROW –file-scope=yes –langmap=c:+.h –languages=c,c++ –links=yes –c-kinds=+p --fields=+S -R -f ~/.vim/systags /usr/include /usr/local/include
check:
	#valgrind --tool=memcheck --show-reachable=yes --leak-check=yes bin/main 2> valgrind.log 1> valgrind.log
	valgrind --tool=memcheck --show-reachable=yes --leak-check=yes bin/main 
	#cat valgrind.log
	@echo "=========================================================================================="
area:
	rm data/widthHeight.csv 
	tclsh scripts/gen_cell_wh.tcl data/sky130hd_std_cell.lef
def:
	# tclsh scripts/gen_def_stat.tcl data/octilinear.def
	tclsh scripts/gen_def_stat.tcl data/simple07.def
