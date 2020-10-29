#=========================================================================
# Makefile dependency fragment
#=========================================================================

ex-sorter-sim-struct: \
  ex-sorter-sim-struct.v \
  ex-sorter-SorterStruct.v \
  ex-sorter-sim-harness.v \
  ex-sorter-MinMaxUnit.v \
  vc-regs.v \
  vc-assert.v \
  vc-trace.v \
  ex-sorter-gen-input_random.py.v \
  ex-sorter-gen-input_sorted-fwd.py.v \
  ex-sorter-gen-input_sorted-rev.py.v \

ex-sorter-sim-struct.d: \
  ex-sorter-sim-struct.v \
  ex-sorter-SorterStruct.v \
  ex-sorter-sim-harness.v \
  ex-sorter-MinMaxUnit.v \
  vc-regs.v \
  vc-assert.v \
  vc-trace.v \

ex-sorter-SorterStruct.v:

ex-sorter-sim-harness.v:

ex-sorter-MinMaxUnit.v:

vc-regs.v:

vc-assert.v:

vc-trace.v:

ex-sorter-gen-input_random.py.v:

ex-sorter-gen-input_sorted-fwd.py.v:

ex-sorter-gen-input_sorted-rev.py.v:

