% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotQ.R
\name{ggtess3Q}
\alias{ggtess3Q}
\title{Display geographic maps of ancestry coefficients using the ggplot grammar}
\usage{
ggtess3Q(Q, coord, resolution = c(300, 300), window = NULL,
  background = TRUE, map.polygon = NULL, raster.filename = NULL,
  interpolation.model = FieldsKrigModel(10), col.palette = CreatePalette())
}
\arguments{
\item{Q}{an object of class \code{tess3Q} corresponding to an ancestry coefficient matrix obtained \code{tess3}.}

\item{coord}{a numeric matrix of dimension \eqn{n} times 2 where \eqn{n} is the
number of individuals. The matrix must contain (Longitude, Latitude) coordinates for all individuals.}

\item{resolution}{an integer vector \code{resolution = c(rx,ry)} for the resolution of the grid used to
computed the interpolating surface. \code{rx} and \code{ry} are resolution numbers for the x-axis and y-axis respectively.}

\item{window}{an integer vector for the plotting window, such that \code{window = c(xmin, xmax, ymin, ymax)}
contains the window's min and max coordinates.}

\item{background}{if \code{TRUE} a raster file is used as a stencil to render only raster pixel on earth.}

\item{map.polygon}{an object of class \code{sp::SpatialPolygonsDataFrame} used to crop the interpolating surface.
If \code{NULL}, the function \code{\link[rworldmap]{getMap}} is used.}

\item{raster.filename}{a raster file name used to compute the background stencil.
This is an alternative method to crop interpolating surfaces. The default method uses \code{map.polygon}.}

\item{interpolation.model}{an interpolation model used to compute the interpolating surface. Interpolation models can use the
functions \code{\link{FieldsTpsModel}} or \code{\link{FieldsKrigModel}}.}

\item{col.palette}{a list of color palettes. Color palettes can be defined by using the function \code{\link{CreatePalette}}.}
}
\value{
None
}
\description{
This function displays geographic maps of ancestry coefficients using the ggplot syntax.
}
\examples{
library(tess3r)

# Load Arabidopsis data
data(data.at)

# Run of TESS3
obj <- tess3(data.at$X, coord = data.at$coord, K = 5,
                 ploidy = 1, method = "projected.ls", openMP.core.num = 4)

# Get the ancestry matrix
Q.matrix <- qmatrix(obj, K = 5)

# Show a spatial interpolation of the ancestry matrix
ggtess3Q(Q.matrix, data.at$coord)
}
\author{
Kevin Caye, Flora Jay, Olivier François
}
