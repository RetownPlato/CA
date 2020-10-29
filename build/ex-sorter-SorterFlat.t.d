#=========================================================================
# Makefile dependency fragment
#=========================================================================

ex-sorter-SorterFlat-test: \
  ex-sorter-SorterFlat.t.v \
  ex-sorter-SorterFlat.v \
  ex-sorter-test-harness.v \
  vc-assert.v \
  vc-trace.v \
  vc-preprocessor.v \
  vc-test.v \
  ex-sorter-gen-input_random.py.v \
  ex-sorter-gen-input_sorted-fwd.py.v \
  ex-sorter-gen-input_sorted-rev.py.v \

ex-sorter-SorterFlat.t.d: \
  ex-sorter-SorterFlat.t.v \
  ex-sorter-SorterFlat.v \
  ex-sorter-test-harness.v \
  vc-assert.v \
  vc-trace.v \
  vc-preprocessor.v \
  vc-test.v \

ex-sorter-SorterFlat.v:

ex-sorter-test-harness.v:

vc-assert.v:

vc-trace.v:

vc-preprocessor.v:

vc-test.v:

ex-sorter-gen-input_random.py.v:

ex-sorter-gen-input_sorted-fwd.py.v:

ex-sorter-gen-input_sorted-rev.py.v:

