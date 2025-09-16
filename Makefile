COMP = gfortran

SRCS = mainprogram.f90 ran_uniform.c erase.f90 trialmovetad.f90 trialbound.f90 trialunbound.f90 trialmoveex.f90 initconfig4.f90 output_eedz.f90
OBJS = mainprogram.o ran_uniform.o erase.o trialmovetad.o trialbound.o trialunbound.o trialmoveex.o initconfig4.o output_eedz.o
PRGM = lat

$(PRGM): $(OBJS)
	$(COMP) -o $(PRGM) $(OBJS)

%.o: %.f90
	$(COMP) -c $<

%.o: %.c
	gcc -c $<

clean:
	rm -f $(PRGM) *.o
