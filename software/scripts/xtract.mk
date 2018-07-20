.PHONY : clean

CLIBS   = -lprotobuf -lpthread  
CFLAGS  = -O2

CFLAGS += $(WRAPPER_FLAGS)

LIBRARY_XTRACT = libparser_arm.so

all: ${LIBRARY_XTRACT}

libcaffeproto_arm.o : ../xtract/caffe.pb.cc ../xtract/caffe.pb.h
	$(ARM_CXX) $(CFLAGS) -c -fPIC -L$(PB_ARM_DIR)/lib -I$(PB_ARM_DIR)/include $< -o $@ $(CLIBS)
	
libcaffeparser_arm.o : ../xtract/caffe_network_parser.cpp
	$(ARM_CXX) $(CFLAGS) -c -fPIC -L$(PB_ARM_DIR)/lib -I$(PB_ARM_DIR)/include $< -o $@ $(CLIBS)
	
xtract_opt_arm.o : ../xtract/xtract_opt.cpp  	
	$(ARM_CXX) $(CFLAGS) -c -fPIC $< -o $@

libxgraph_arm.o : ../xtract/xgraph.cpp ../xtract/xgraph.hpp ../xtract/xparameter.hpp
	$(ARM_CXX) $(CFLAGS) -c -fPIC $< -o $@
	
libxifuncs_arm.o : ../xtract/xi_funcs.cpp ../xtract/xi_funcs.hpp
	$(ARM_CXX) $(CFLAGS) -c -fPIC $< -o $@

xtract_utility_arm.o : ../xtract/xtract_utility.cpp
	$(ARM_CXX) $(CFLAGS) -c -fPIC $< -o $@
	
${LIBRARY_XTRACT}: libcaffeparser_arm.o libxgraph_arm.o libcaffeproto_arm.o libxifuncs_arm.o xtract_opt_arm.o xtract_utility_arm.o
	$(ARM_CXX) $(CFLAGS) -shared -fPIC -Wl,-soname,libparser_arm.so -o $@ $^	

copy :
	cp *.so $(LIB_DIR)
	
clean :
	rm -rf *.o

ultraclean :
	rm -rf *.o *.so
