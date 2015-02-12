#!/bin/bash

set -e
set -x

xcodebuild -scheme PCFAuthTests clean build test
