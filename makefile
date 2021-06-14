# programming environment
CLASSPATH = /home/emilio/Codes/hi_class_pub_devel
COMPILER     := mpic++
INCLUDE      := -I /home/emilio/Codes/LATfield2 -I /usr/lib/x86_64-linux-gnu/hdf5/serial/include -I $(CLASSPATH)/include #-I $(CLASSPATH)/external/HyRec2020 -I $(CLASSPATH)/external/RecfastCLASS -I $(CLASSPATH)/external/heating # add the path to LATfield2 and other libraries (if necessary)
LIB          := -lfftw3 -lm -lhdf5 -lgsl -lgslcblas -lclass -L /usr/lib/x86_64-linux-gnu/hdf5/serial/lib -L $(CLASSPATH)
#HPXCXXLIB    := -lhealpix_cxx -lcfitsio

# target and source
EXEC         := gevolution
SOURCE       := main.cpp
HEADERS      := $(wildcard *.hpp)

# mandatory compiler settings (LATfield2)
DLATFIELD2   := -DFFT3D -DHDF5

# optional compiler settings (LATfield2)
#DLATFIELD2   += -DH5_HAVE_PARALLEL
#DLATFIELD2   += -DEXTERNAL_IO # enables I/O server (use with care)
#DLATFIELD2   += -DSINGLE      # switches to single precision, use LIB -lfftw3f

# optional compiler settings (gevolution)
DGEVOLUTION  := -DPHINONLINEAR
DGEVOLUTION  += -DBENCHMARK
#DGEVOLUTION  += -DBACKREACTION_TEST
DGEVOLUTION  += -DEXACT_OUTPUT_REDSHIFTS
#DGEVOLUTION  += -DVELOCITY      # enables velocity field utilities
#DGEVOLUTION  += -DCOLORTERMINAL
#DGEVOLUTION  += -DCHECK_B
DGEVOLUTION  += -DHAVE_CLASS    # requires LIB -lclass
#DGEVOLUTION  += -DHAVE_HEALPIX  # requires LIB -lchealpix
DMGEVOLUTION  := -DHAVE_CLASS_BG  # requires LIB -lclass, You must have -DHAVE_CLASS

# further compiler options
OPT          := -O3 -std=c++11

$(EXEC): $(SOURCE) $(HEADERS) makefile
	$(COMPILER) $< -o $@ $(OPT) $(DLATFIELD2) $(DGEVOLUTION) $(DMGEVOLUTION) $(INCLUDE) $(LIB)
	
lccat: lccat.cpp
	$(COMPILER) $< -o $@ $(OPT) $(DGEVOLUTION) $(DMGEVOLUTION) $(INCLUDE)
	
lcmap: lcmap.cpp
	$(COMPILER) $< -o $@ $(OPT) -fopenmp $(DGEVOLUTION) $(DMGEVOLUTION) $(INCLUDE) $(LIB) $(HPXCXXLIB)

clean:
	-rm -f $(EXEC) lccat lcmap
