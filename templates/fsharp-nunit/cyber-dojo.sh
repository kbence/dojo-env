#!/bin/bash

fsharpc --nologo \
        --target:library \
        -r:/sandbox/nunit.framework.dll \
        -o RunTests.dll *.fs

if [ $? -eq 0 ]; then
  mono /Packages/NUnit.Runners/tools/nunit-console.exe -nologo /sandbox/RunTests.dll
fi
