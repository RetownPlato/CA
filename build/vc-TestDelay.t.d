#=========================================================================
# Makefile dependency fragment
#=========================================================================

vc-TestDelay-test: \
  vc-TestDelay.t.v \
  vc-TestSource.v \
  vc-TestSink.v \
  vc-TestDelay.v \
  vc-test.v \
  vc-trace.v \
  vc-regs.v \
  vc-assert.v \
  vc-test-src-sink-gen-input_ordered.py.v \

vc-TestDelay.t.d: \
  vc-TestDelay.t.v \
  vc-TestSource.v \
  vc-TestSink.v \
  vc-TestDelay.v \
  vc-test.v \
  vc-trace.v \
  vc-regs.v \
  vc-assert.v \

vc-TestSource.v:

vc-TestSink.v:

vc-TestDelay.v:

vc-test.v:

vc-trace.v:

vc-regs.v:

vc-assert.v:

vc-test-src-sink-gen-input_ordered.py.v:

