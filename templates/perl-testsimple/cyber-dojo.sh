#!/bin/bash
perl -MTest::Harness -wle 'runtests @ARGV' *.t
