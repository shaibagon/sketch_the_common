#include "mex.h"

/*
 * Compute location offsets into a sparse complex matrix
 *
 * Usage:
 *  OS = loc_offset_mex(locs, thr, os)
 *
 * Inputs: 
 *  - locs 2xN double array
 *  - thr  scalar thershold of offset (L2)
 *  - os   scalar linear addition to offset
 */

#define     LIN     0
#define     TIN     1
#define     OIN     2
#define     BLK_SZ  (2^10)

void
mexFunction(
    int nout,
    mxArray* pout[],
    int nin,
    const mxArray* pin[])
{
    if ( nin != 3 )
         mexErrMsgIdAndTxt("loc_offset_mex:nin","must have 3 inputs");
    if (nout==0)
        return;
    if (nout > 1 )
        mexErrMsgIdAndTxt("loc_offset_mex:nout","must have exactly one output");

    // location is expected to be of int16
    if (mxGetClassID(pin[LIN]) != mxDOUBLE_CLASS || mxIsComplex(pin[LIN]))
        mexErrMsgIdAndTxt("loc_offset_mex:locs_type", "locs must be real double array");
    
    if (mxGetM(pin[LIN])!=2)
        mexErrMsgIdAndTxt("loc_offset_mex:locs_dim", "locs must be in 2D");

    double* plocs = mxGetPr(pin[LIN]);
    
    mwSize N = mxGetN(pin[LIN]); // number of locations/points
    
    // thershold
    if (mxGetNumberOfElements(pin[TIN])!=1 || mxIsComplex(pin[TIN]))
        mexErrMsgIdAndTxt("loc_offset_mex:thr", "thr must be a real-valued scalar");
    double thr = mxGetScalar(pin[TIN]);
    if (thr <= 0 )
        mexErrMsgIdAndTxt("loc_offset_mex:thr", "thr must be positive");
    
    // offset
    if (mxGetNumberOfElements(pin[OIN])!=1 || mxIsComplex(pin[OIN]))
        mexErrMsgIdAndTxt("loc_offset_mex:os", "offset must be a real-valued scalar");
    double os = mxGetScalar(pin[OIN]);
    if (thr < 0 )
        mexErrMsgIdAndTxt("loc_offset_mex:os", "thr must be strictly positive");
    
    mwSize ALLC = (mwSize)(thr*N*4);
    
    // construct the sparse offsets matrix
    pout[0] = mxCreateSparse(N, N, ALLC, mxCOMPLEX);

    double* pdr = mxGetPr(pout[0]);// real part of OS 
    double* pdc = mxGetPi(pout[0]);// imaginary part
    mwIndex* pir = mxGetIr(pout[0]);
    mwIndex* pjc = mxGetJc(pout[0]);
        
   
    mwIndex nnz = 0; // count total number of elements in OS monitor mem allocation
    for ( mwSize ii=0; ii < N ; ii++ ) {
        pjc[ii] = nnz;
        for ( mwSize jj=ii+1; jj < N ; jj++ ) { // construc only the lower triangular part
            // new offset
            double dr = plocs[2*ii] - plocs[2*jj];
            double dc = plocs[2*ii+1] - plocs[2*jj+1];
            
            // below thr?
            if (dr*dr+dc*dc>thr)
                continue;
            
            if ( nnz == ALLC ) {
                ALLC += BLK_SZ;
                // we need to allocate new memory
                mxSetNzmax(pout[0], ALLC);
                mxSetIr(pout[0], (mwIndex*)mxRealloc(pir, ALLC*sizeof(mwIndex) ));
                mxSetPr(pout[0], (double*)mxRealloc(pdr, ALLC*sizeof(double) ));
                mxSetPi(pout[0], (double*)mxRealloc(pdc, ALLC*sizeof(double) ));
                
                pdr = mxGetPr(pout[0]);// real part of OS
                pdc = mxGetPi(pout[0]);// imaginary part
                pir = mxGetIr(pout[0]);
                
            }
            // update the relevant arrays
            pir[nnz] = jj;
            pdr[nnz] = dr + os;
            pdc[nnz] = dc + os;
            if ( dc+os < 1 ) {
                mexPrintf("look at ii=%d jj=%d dr=%.0f dc=%.0f\n", ii, jj, dr, dc);
                return;
            }
            nnz++;        
        } // end of jj loop
    } // end of ii loop
    pjc[N] = nnz;

    mxSetNzmax(pout[0], nnz);
    mxSetIr(pout[0], (mwIndex*)mxRealloc(pir, nnz*sizeof(mwIndex) ));
    mxSetPr(pout[0], (double*)mxRealloc(pdr, nnz*sizeof(double) ));
    mxSetPi(pout[0], (double*)mxRealloc(pdc, nnz*sizeof(double) ));
}
