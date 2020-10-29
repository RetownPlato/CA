#=========================================================================
# Makefile dependency fragment
#=========================================================================

ex-sorter-sim-flat: \
  ex-sorter-sim-flat.v \
  ex-sorter-SorterFlat.v \
  ex-sorter-sim-harness.v \
  vc-assert.v \
  vc-trace.v \
  ex-sorter-gen-input_random.py.v \
  ex-sorter-gen-input_sorted-fwd.py.v \
  ex-sorter-gen-input_sorted-rev.py.v \

ex-sorter-sim-flat.d: \
  ex-sorter-sim-flat.v \
  ex-sorter-SorterFlat.v \
  ex-sorter-sim-harness.v \
  vc-assert.v \
  vc-trace.v \

ex-sorter-SorterFlat.v:

ex-sorter-sim-harness.v:

vc-assert.v:

vc-trace.v:

ex-sorter-gen-input_random.py.v:

ex-sorter-gen-input_sorted-fwd.py.v:

ex-sorter-gen-input_sorted-rev.py.v:

