# ==============================================================================
# scclust for R -- R wrapper for the scclust library
# https://github.com/fsavje/scclust-R
#
# Copyright (C) 2016-2017  Fredrik Savje -- http://fredriksavje.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/
# ==============================================================================

library(scclust)
context("scclust.R")


# ==============================================================================
# scclust
# ==============================================================================

cl_labels <- as.integer(c(0, 0, 1, 2, 1, 2, 2, 0, 1, 1))
cl_labels_wNA <- as.integer(c(0, 0, 1, 2, NA, 2, 2, NA, 1, 1))

cl_obj_simple <- structure(cl_labels,
                           cluster_count = 3L,
                           ids = NULL,
                           class = c("scclust"))

cl_obj_wNA <- structure(cl_labels_wNA,
                        cluster_count = 3L,
                        ids = NULL,
                        class = c("scclust"))

cl_obj_wID <- structure(cl_labels,
                        cluster_count = 3L,
                        ids = letters[1:10],
                        class = c("scclust"))

cl_obj_wIDnNA <- structure(cl_labels_wNA,
                           cluster_count = 3L,
                           ids = letters[1:10],
                           class = c("scclust"))

test_that("`scclust` returns correct output", {
  expect_identical(scclust(c("A", "A", "B", "C", "B", "C", "C", "A", "B", "B")),
                   cl_obj_simple)
  expect_identical(scclust(c(1, 1, 2, 3, 2, 3, 3, 1, 2, 2)),
                   cl_obj_simple)
  expect_identical(scclust(c("A", "A", "B", "C", "NONE", "C", "C", "NONE", "B", "B"), "NONE"),
                   cl_obj_wNA)
  expect_identical(scclust(c("A", "A", "B", "C", "NONE", "C", "C", "0", "B", "B"), c("NONE", "0")),
                   cl_obj_wNA)
  expect_identical(scclust(c(1, 1, 2, 3, 0, 3, 3, 0, 2, 2), 0),
                   cl_obj_wNA)
  expect_identical(scclust(c("A", "A", "B", "C", "B", "C", "C", "A", "B", "B"), ids = letters[1:10]),
                   cl_obj_wID)
  expect_identical(scclust(c("A", "A", "B", "C", "NONE", "C", "C", "0", "B", "B"), c("NONE", "0"), ids = letters[1:10]),
                   cl_obj_wIDnNA)
})


# ==============================================================================
# is.scclust
# ==============================================================================

test_that("`is.scclust` returns correct output", {
  expect_true(is.scclust(cl_obj_simple))
  expect_true(is.scclust(structure(1:10L,
                                   cluster_count = 10L,
                                   ids = NULL,
                                   class = c("scclust"))))
  expect_false(is.scclust(structure(letters[1:10],
                                    cluster_count = 10L,
                                    ids = NULL,
                                    class = c("scclust"))))
  expect_false(is.scclust(structure(1:10L,
                                    cluster_count = 10L,
                                    ids = NULL,
                                    class = c("abc"))))
  expect_false(is.scclust(structure(1:10L,
                                    ids = NULL,
                                    class = c("scclust"))))
  expect_false(is.scclust(structure(1:10L,
                                    cluster_count = 1:2,
                                    ids = NULL,
                                    class = c("scclust"))))
  expect_false(is.scclust(structure(1:10L,
                                    cluster_count = -10L,
                                    ids = NULL,
                                    class = c("scclust"))))
})


# ==============================================================================
# cluster_count
# ==============================================================================

test_that("`cluster_count` returns correct output", {
  expect_identical(cluster_count(scclust(c("a", "b", "c", "a", "b", "c", "a"))),
                   3L)
  expect_identical(cluster_count(scclust(c("a", "b", "c", "a", "b", "c", "a", "d", "e", "d"))),
                   5L)
})


# ==============================================================================
# length.scclust
# ==============================================================================

test_that("`length.scclust` returns correct output", {
  expect_identical(length(scclust(c("a", "b", "c", "a", "b", "c", "a"))),
                   7L)
  expect_identical(length(scclust(c("a", "b", "c", "a", "b", "c", "a", "d", "e", "d"))),
                   10L)
})


# ==============================================================================
# as.data.frame.scclust
# ==============================================================================

test_that("`as.data.frame.scclust` returns correct output", {
  expect_identical(as.data.frame(cl_obj_simple),
                   data.frame(id = 1:10, cluster_label = cl_labels))
  expect_identical(as.data.frame(cl_obj_wNA),
                   data.frame(id = 1:10, cluster_label = cl_labels_wNA))
  expect_identical(as.data.frame(cl_obj_wID),
                   data.frame(id = letters[1:10], cluster_label = cl_labels))
  expect_identical(as.data.frame(cl_obj_wIDnNA),
                   data.frame(id = letters[1:10], cluster_label = cl_labels_wNA))
})


# ==============================================================================
# print.scclust
# ==============================================================================

test_that("`print.scclust` prints correctly", {
  expect_output(print(cl_obj_simple), "0  0  1  2  1  2  2  0  1  1", fixed = TRUE)
})
