#!/bin/bash
# Compiling needed files
elixirc ../utils.ex
elixirc ../test_utils.ex
elixirc part_1.ex
elixirc part_2.ex

# Executing tests
# If no error is raised, the code works as expected
elixir test.exs
