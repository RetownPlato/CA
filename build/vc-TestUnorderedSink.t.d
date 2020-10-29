#=========================================================================
# Makefile dependency fragment
#=========================================================================

vc-TestUnorderedSink-test: \
  vc-TestUnorderedSink.t.v \
  vc-TestSource.v \
  vc-TestUnorderedSink.v \
  vc-test.v \
  vc-trace.v \
  vc-regs.v \
  vc-assert.v \

vc-TestUnorderedSink.t.d: \
  vc-TestUnorderedSink.t.v \
  vc-TestSource.v \
  vc-TestUnorderedSink.v \
  vc-test.v \
  vc-trace.v \
  vc-regs.v \
  vc-assert.v \

vc-TestSource.v:

vc-TestUnorderedSink.v:

vc-test.v:

vc-trace.v:

vc-regs.v:

vc-assert.v:

