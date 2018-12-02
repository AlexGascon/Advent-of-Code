#!/bin/bash
# Compiling needed files
elixirc ../utils.ex

# Executing tests
# If no error is raised, the code works as expected
elixir part_1.exs
elixir part_2.exs
