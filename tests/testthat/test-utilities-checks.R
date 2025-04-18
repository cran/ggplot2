
test_that("check_device checks R versions correctly", {

  # Most widely supported device
  file <- withr::local_tempfile(fileext = ".pdf")
  withr::local_pdf(file)

  # R 4.0.0 doesn't support any new features
  with_mocked_bindings(
    getRversion = function() package_version("4.0.0"),
    expect_warning(check_device("gradients"), "R 4.0.0 does not support"),
    .package = "base"
  )

  # R 4.1.0 doesn't support vectorised patterns
  with_mocked_bindings(
    getRversion = function() package_version("4.1.0"),
    expect_warning(check_device("gradients"), "R 4.1.0 does not support"),
    .package = "base"
  )

  # R 4.1.0 does support clipping paths
  with_mocked_bindings(
    getRversion = function() package_version("4.1.0"),
    expect_true(check_device("clippingPaths"), "R 4.1.0 does not support"),
    .package = "base"
  )

  # Glyphs are only supported in R 4.3.0 onwards
  with_mocked_bindings(
    getRversion = function() package_version("4.2.0"),
    expect_warning(check_device("glyphs"), "R 4.2.0 does not support"),
    .package = "base"
  )

  # R 4.2.0 does support vectorised patterns
  with_mocked_bindings(
    getRversion = function() package_version("4.2.0"),
    expect_true(check_device("patterns")),
    .package = "base"
  )
})

test_that("check_device finds device capabilities", {
  skip_if(
    getRversion() < "4.2.0",
    "R version < 4.2.0 does doesn't have proper `dev.capabilities()`."
  )
  file <- withr::local_tempfile(fileext = ".pdf")
  withr::local_pdf(file)
  with_mocked_bindings(
    dev.capabilities = function() list(clippingPaths = TRUE),
    expect_true(check_device("clippingPaths")),
    .package = "grDevices"
  )

  with_mocked_bindings(
    dev.capabilities = function() list(clippingPaths = FALSE),
    expect_warning(check_device("clippingPaths"), "does not support"),
    .package = "grDevices"
  )

  with_mocked_bindings(
    dev.cur = function() c(foobar = 1),
    expect_warning(check_device(".test_feature"), "Unable to check"),
    .package = "grDevices"
  )

})
