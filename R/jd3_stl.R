
#' Title
#'
#' Perform an STL like (based on Loess) decomposition on any periodicity
#'
#' @param y input time series.
#' @param period period, any positive real number.
#' @param multiplicative Boolean indicating if the decomposition mode is multiplicative (TRUE).
#' @param swindow length of seasonal filter.
#' @param twindow length of trend filter.
#' @param ninnerloop Number of inner loops
#' @param nouterloop Number of outer loops (computation of robust weights) 
#' @param nojump 
#' @param weight.threshold Weights threshold (in [0, 0.3])
#' @param weight.function weights function
#'
#' @return
#' @export
#'
#' @examples
stl<-function(y, period, multiplicative=TRUE, swindow=7, twindow=0, ninnerloop=1, nouterloop=15, nojump=FALSE, weight.threshold=0.001, 
    weight.function=c('BIWEIGHT', 'UNIFORM', 'TRIANGULAR', 'EPANECHNIKOV', 'TRICUBE', 'TRIWEIGHT')){
  weight.function=match.arg(weight.function)
  
  jrslt<-.jcall("demetra/stl/r/StlDecomposition", "Ldemetra/math/matrices/Matrix;", "stl", as.numeric(y), as.integer(period), as.logical(multiplicative), as.integer(swindow), as.integer(twindow), 
                as.integer(ninnerloop), as.integer(nouterloop), as.logical(nojump), as.numeric(weight.threshold), as.character(weight.function))
  m<-rjd3toolkit::matrix_jd2r(jrslt)
  colnames(m)<-c('y', 'sa', 't', 's', 'i', 'fit', 'weights')
  parameters<-list(
    multiplicative=multiplicative, 
    swindow=swindow, 
    twindow=twindow, 
    ninnerloop=ninnerloop,
    nouterloop=nouterloop,
    weight.threshold=weight.threshold,
    weight.function=weight.function
  )

  return(structure(list(
    decomposition=m,
    parameters=parameters),
    class="JDSTL"))
}

#' Title
#'
#' @param y 
#' @param periods 
#' @param multiplicative 
#' @param swindows 
#' @param twindow 
#' @param ninnerloop 
#' @param nouterloop 
#' @param nojump 
#' @param weight.threshold 
#' @param weight.function 
#'
#' @return
#' @export
#'
#' @examples
mstl<-function(y, periods, multiplicative=TRUE, swindows=NULL, twindow=0, ninnerloop=1, nouterloop=15, nojump=FALSE, weight.threshold=0.001, 
              weight.function=c('BIWEIGHT', 'UNIFORM', 'TRIANGULAR', 'EPANECHNIKOV', 'TRICUBE', 'TRIWEIGHT')){
  weight.function=match.arg(weight.function)
  
  if (is.null(swindows))
    swin<-.jnull("[I")
  else
    swin<-.jarray(as.integer(swindows))
  
  jrslt<-.jcall("demetra/stl/r/StlDecomposition", "Ldemetra/math/matrices/Matrix;", "mstl", as.numeric(y), .jarray(as.integer(periods)), as.logical(multiplicative), swin, as.integer(twindow), 
                as.integer(ninnerloop), as.integer(nouterloop), as.logical(nojump), as.numeric(weight.threshold), as.character(weight.function))
  m<-rjd3toolkit::matrix_jd2r(jrslt)
  
  snames<-paste('s', as.integer(periods), sep='')
  colnames(m)<-c('y', 'sa', 't', snames, 'i', 'fit', 'weights')
  parameters<-list(
    multiplicative=multiplicative, 
    swindow=swindows, 
    twindow=twindow, 
    ninnerloop=ninnerloop,
    nouterloop=nouterloop,
    weight.threshold=weight.threshold,
    weight.function=weight.function
  )
  
  return(structure(list(
    decomposition=m,
    parameters=parameters),
    class="JDSTL"))
}

#' Title
#'
#' @param y 
#' @param periods 
#' @param multiplicative 
#' @param swindows 
#' @param twindows 
#' @param ninnerloop 
#' @param nouterloop 
#' @param nojump 
#' @param weight.threshold 
#' @param weight.function 
#'
#' @return
#' @export
#'
#' @examples
istl<-function(y, periods, multiplicative=TRUE, swindows=NULL, twindows=NULL, ninnerloop=1, nouterloop=15, nojump=FALSE, weight.threshold=0.001, 
              weight.function=c('BIWEIGHT', 'UNIFORM', 'TRIANGULAR', 'EPANECHNIKOV', 'TRICUBE', 'TRIWEIGHT')){
  weight.function=match.arg(weight.function)
  if (is.null(swindows))
    swin<-.jnull("[I")
  else
    swin<-.jarray(as.integer(swindows))
  if (is.null(twindows))
    twin<-.jnull("[I")
  else
    twin<-.jarray(as.integer(twindows))
  
  jrslt<-.jcall("demetra/stl/r/StlDecomposition", "Ldemetra/math/matrices/Matrix;", "istl", as.numeric(y), .jarray(as.integer(periods)), as.logical(multiplicative), swin, twin, 
                as.integer(ninnerloop), as.integer(nouterloop), as.logical(nojump), as.numeric(weight.threshold), as.character(weight.function))
  m<-rjd3toolkit::matrix_jd2r(jrslt)
  snames<-paste('s', as.integer(periods), sep='')
  colnames(m)<-c('y', 'sa', 't', snames, 'i', 'fit', 'weights')
  parameters<-list(
    multiplicative=multiplicative, 
    swindows=swindows, 
    twindows=twindows, 
    ninnerloop=ninnerloop,
    nouterloop=nouterloop,
    weight.threshold=weight.threshold,
    weight.function=weight.function
  )
  
  return(structure(list(
    decomposition=m,
    parameters=parameters),
    class="JDSTL"))
}



#' Fit a Loess regression.
#'
#' @param y input time series.
#' @param window 
#' @param degree 
#' @param jump 
#'
#' @return
#' @export
#'
#' @examples
loess<-function(y, window, degree=1, jump=1){
  if (degree != 0 && degree != 1)
    stop("Unsupported degree")
  if (jump <1)
    stop("jump should be greater then 0")
  return (.jcall("demetra/r/StlDecomposition", "[D", "loess", as.numeric(y), as.integer(window), as.integer(degree), as.integer(jump)))
}

