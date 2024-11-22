CXX := g++
CXXFLAGS := -pedantic -std=c++20 -fopenmp 
RELEASEFLAGS := -O3

# List of source files
SRCS := sim.cc io.cc
HEADERS := io.h collision.h sim_validator.h

# Object files
OBJS := $(SRCS:.cc=.o)

.PHONY: all clean

all: release

# List of executables (actual binary names)
EXECUTABLES := sim
PERF_EXECUTABLES := $(EXECUTABLES:%=%.perf)

TARGETS := $(EXECUTABLES) 
PERF_TARGETS := $(PERF_EXECUTABLES)

release: $(TARGETS) $(PERF_TARGETS)

# How to compile .o and .o.perf object files
%.o: %.cc $(HEADERS)
	$(CXX) $(CXXFLAGS) -DCHECK=1 $(RELEASEFLAGS) -c $< -o $@
%.o.perf: %.cc $(HEADERS)
	$(CXX) $(CXXFLAGS) -DCHECK=0 $(RELEASEFLAGS) -c $< -o $@

# How to compile non-perf and perf executables
$(EXECUTABLES): %: %.o io.o sim_validator.a
	$(CXX) $(CXXFLAGS) -DCHECK=1 $(RELEASEFLAGS) -o $@ $^
$(PERF_EXECUTABLES): %.perf: %.o.perf io.o
	$(CXX) $(CXXFLAGS) -DCHECK=0 $(RELEASEFLAGS) -o $@ $^

clean:
	$(RM) *.o *.o.perf $(EXECUTABLES) $(PERF_EXECUTABLES)
	$(RM) bonus bonus.perf e1091280 e1091280.perf

bonus:
	$(CXX) $(CXXFLAGS) -DCHECK=1 sim_validator.a io.cc sim.cc -o bonus
	$(CXX) $(CXXFLAGS) -DCHECK=0 io.cc sim.cc -o bonus.perf

submit:
	$(CXX) $(CXXFLAGS) -DCHECK=1 sim_validator.a io.cc sim.cc -o e1091280
	$(CXX) $(CXXFLAGS) -DCHECK=0 io.cc sim.cc -o bonus.perf -o e1091280.perf

debug:
	$(CXX) $(CXXFLAGS) -DCHECK=1 -g sim_validator.a io.cc sim.cc -o debug
	$(CXX) $(CXXFLAGS) -DCHECK=0 io.cc sim.cc -o bonus.perf -o debug.perf



