#=========================================================================
# Makefile dependency fragment
#=========================================================================

vc-TestRandDelay-test: \
  vc-TestRandDelay.t.v \
  vc-TestSource.v \
  vc-TestSink.v \
  vc-TestRandDelay.v \
  vc-test.v \
  vc-trace.v \
  vc-regs.v \
  vc-assert.v \
  vc-test-src-sink-gen-input_ordered.py.v \

vc-TestRandDelay.t.d: \
  vc-TestRandDelay.t.v \
  vc-TestSource.v \
  vc-TestSink.v \
  vc-TestRandDelay.v \
  vc-test.v \
  vc-trace.v \
  vc-regs.v \
  vc-assert.v \

vc-TestSource.v:

vc-TestSink.v:

vc-TestRandDelay.v:

vc-test.v:

vc-trace.v:

vc-regs.v:

vc-assert.v:

vc-test-src-sink-gen-input_ordered.py.v:

