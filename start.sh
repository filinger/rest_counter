#!/bin/sh
erl -pa ebin deps/*/ebin -s rest_counter
