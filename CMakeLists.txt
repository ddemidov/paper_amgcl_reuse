cmake_minimum_required(VERSION 3.11)
project(reuse)

find_package(LATEX)
if (LATEX_FOUND)
    include(UseLATEX.cmake)
    add_latex_document(
        amgcl_reuse.tex
        BIBFILES ref.bib
        DEPENDS ljm.sty spmpsci.bst
        )
endif()

add_subdirectory(data)
