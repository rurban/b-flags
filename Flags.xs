#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

typedef OP  *B__OP;
typedef SV  *B__SV;

MODULE = B::Flags		PACKAGE = B::OP		

SV*
flagspv(o)
    B::OP   o
    CODE:
        RETVAL = newSVpvn("", 0);
        switch (o->op_flags & OPf_WANT) {
        case OPf_WANT_VOID:
            sv_catpv(RETVAL, ",VOID");
            break;
        case OPf_WANT_SCALAR:
            sv_catpv(RETVAL, ",SCALAR");
            break;
        case OPf_WANT_LIST:
            sv_catpv(RETVAL, ",LIST");
            break;
        default:
            sv_catpv(RETVAL, ",UNKNOWN");
            break;
        }
        if (o->op_flags & OPf_KIDS)
            sv_catpv(RETVAL, ",KIDS");
        if (o->op_flags & OPf_PARENS)
            sv_catpv(RETVAL, ",PARENS");
        if (o->op_flags & OPf_STACKED)
            sv_catpv(RETVAL, ",STACKED");
        if (o->op_flags & OPf_REF)
            sv_catpv(RETVAL, ",REF");
        if (o->op_flags & OPf_MOD)
            sv_catpv(RETVAL, ",MOD");
        if (o->op_flags & OPf_SPECIAL)
            sv_catpv(RETVAL, ",SPECIAL");
        if (SvCUR(RETVAL))
            sv_chop(RETVAL, SvPVX(RETVAL)+1); /* Ow. */
    OUTPUT:
        RETVAL

SV*
privatepv(o)
    B::OP   o
    CODE:
        RETVAL = newSVpvn("", 0);
        /* This needs past-proofing. :) */
        if (PL_opargs[o->op_type] & OA_TARGLEX) {
#ifdef OPpTARGET_MY
            if (o->op_private & OPpTARGET_MY)
                sv_catpv(RETVAL, ",TARGET_MY");
#endif
        }
#ifdef OPpREFCOUNTED
        else if (o->op_type == OP_LEAVESUB ||
                 o->op_type == OP_LEAVE ||
                 o->op_type == OP_LEAVESUBLV ||
                 o->op_type == OP_LEAVEWRITE) {
            if (o->op_private & OPpREFCOUNTED)
                sv_catpv(RETVAL, ",REFCOUNTED");
        }
#endif
        else if (o->op_type == OP_AASSIGN) {
#ifdef  OPpASSIGN_COMMON
            if (o->op_private & OPpASSIGN_COMMON)
                sv_catpv(RETVAL, ",COMMON");
#endif
#ifdef  OPpASSIGN_HASH
            if (o->op_private & OPpASSIGN_HASH)
                sv_catpv(RETVAL, ",HASH");
#endif
        }
#ifdef  OPpASSIGN_BACKWARDS
        else if (o->op_type == OP_SASSIGN) {
            if (o->op_private & OPpASSIGN_BACKWARDS)
                sv_catpv(RETVAL, ",BACKWARDS");
        }
#endif
        else if (o->op_type == OP_TRANS) {
#ifdef OPpTRANS_SQUASH
            if (o->op_private & OPpTRANS_SQUASH)
                sv_catpv(RETVAL, ",SQUASH");
#endif
#ifdef OPpTRANS_DELETE
            if (o->op_private & OPpTRANS_DELETE)
                sv_catpv(RETVAL, ",DELETE");
#endif
#ifdef OPpTRANS_COMPLEMENT
            if (o->op_private & OPpTRANS_COMPLEMENT)
                sv_catpv(RETVAL, ",COMPLEMENT");
#endif
#ifdef OPpTRANS_IDENTICAL
            if (o->op_private & OPpTRANS_IDENTICAL)
                sv_catpv(RETVAL, ",IDENTICAL");
#endif
#ifdef OPpTRANS_GROWS
            if (o->op_private & OPpTRANS_GROWS)
                sv_catpv(RETVAL, ",GROWS");
#endif
        }
        else if (o->op_type == OP_REPEAT) {
#ifdef OPpREPEAT_DOLIST
            if (o->op_private & OPpREPEAT_DOLIST)
                sv_catpv(RETVAL, ",DOLIST");
#endif
        }
        else if (o->op_type == OP_ENTERSUB ||
                 o->op_type == OP_RV2SV ||
                 o->op_type == OP_GVSV ||
                 o->op_type == OP_RV2AV ||
                 o->op_type == OP_RV2HV ||
                 o->op_type == OP_RV2GV ||
                 o->op_type == OP_AELEM ||
                 o->op_type == OP_HELEM )
        {
            if (o->op_type == OP_ENTERSUB) {
#ifdef OPpENTERSUB_AMPER
                if (o->op_private & OPpENTERSUB_AMPER)
                    sv_catpv(RETVAL, ",AMPER");
#endif
#ifdef OPpENTERSUB_DB
                if (o->op_private & OPpENTERSUB_DB)
                    sv_catpv(RETVAL, ",DB");
#endif
#ifdef OPpENTERSUB_HASTARG
                if (o->op_private & OPpENTERSUB_HASTARG)
                    sv_catpv(RETVAL, ",HASTARG");
#endif
#ifdef OPpENTERSUB_NOPAREN
                if (o->op_private & OPpENTERSUB_NOPAREN)
                    sv_catpv(RETVAL, ",NOPAREN");
#endif
#ifdef OPpENTERSUB_INARGS
                if (o->op_private & OPpENTERSUB_INARGS)
                    sv_catpv(RETVAL, ",INARGS");
#endif
            }
            else {
#ifdef OPpDEREF
                switch (o->op_private & OPpDEREF) {
            case OPpDEREF_SV:
                sv_catpv(RETVAL, ",SV");
                break;
            case OPpDEREF_AV:
                sv_catpv(RETVAL, ",AV");
                break;
            case OPpDEREF_HV:
                sv_catpv(RETVAL, ",HV");
                break;
            }
#endif
#ifdef OPpMAYBE_LVSUB
                if (o->op_private & OPpMAYBE_LVSUB)
                    sv_catpv(RETVAL, ",MAYBE_LVSUB");
#endif
            }
            if (o->op_type == OP_AELEM || o->op_type == OP_HELEM) {
#ifdef OPpLVAL_DEFER
                if (o->op_private & OPpLVAL_DEFER)
                    sv_catpv(RETVAL, ",LVAL_DEFER");
#endif
            }
            else {
                if (o->op_private & HINT_STRICT_REFS)
                    sv_catpv(RETVAL, ",STRICT_REFS");
#ifdef OPpOUR_INTRO
                if (o->op_private & OPpOUR_INTRO)
                    sv_catpv(RETVAL, ",OUR_INTRO");
#endif
            }
        }
        else if (o->op_type == OP_CONST) {
#ifdef OPpCONST_BARE
            if (o->op_private & OPpCONST_BARE)
                sv_catpv(RETVAL, ",BARE");
#endif
#ifdef OPpCONST_STRICT
            if (o->op_private & OPpCONST_STRICT)
                sv_catpv(RETVAL, ",STRICT");
#endif
#ifdef OPpCONST_ARYBASE
            if (o->op_private & OPpCONST_ARYBASE)
                sv_catpv(RETVAL, ",ARYBASE");
#endif
#ifdef OPpCONST_WARNING
            if (o->op_private & OPpCONST_WARNING)
                sv_catpv(RETVAL, ",WARNING");
#endif
#ifdef OPpCONST_ENTERED
            if (o->op_private & OPpCONST_ENTERED)
                sv_catpv(RETVAL, ",ENTERED");
#endif
        }
#ifdef OPpFLIP_LINENUM
        else if (o->op_type == OP_FLIP) {
            if (o->op_private & OPpFLIP_LINENUM)
                sv_catpv(RETVAL, ",LINENUM");
        }
        else if (o->op_type == OP_FLOP) {
            if (o->op_private & OPpFLIP_LINENUM)
                sv_catpv(RETVAL, ",LINENUM");
        } 
#endif
#ifdef OPpLVAL_INTRO
        else if (o->op_type == OP_RV2CV) {
            if (o->op_private & OPpLVAL_INTRO)
                sv_catpv(RETVAL, ",INTRO");
        }
#endif
#ifdef OPpEARLY_CV
        else if (o->op_type == OP_GV) {
            if (o->op_private & OPpEARLY_CV)
                sv_catpv(RETVAL, ",EARLY_CV");
        }
#endif
#ifdef OPpLIST_GUESSED
        else if (o->op_type == OP_LIST) {
            if (o->op_private & OPpLIST_GUESSED)
                sv_catpv(RETVAL, ",GUESSED");
        }
#endif
#ifdef OPpSLICE
        else if (o->op_type == OP_DELETE) {
            if (o->op_private & OPpSLICE)
                sv_catpv(RETVAL, ",SLICE");
        }
#endif
#ifdef OPpEXISTS_SUB
        else if (o->op_type == OP_EXISTS) {
            if (o->op_private & OPpEXISTS_SUB)
                sv_catpv(RETVAL, ",EXISTS_SUB");
        }
#endif
        else if (o->op_type == OP_SORT) {
#ifdef OPpSORT_NUMERIC
            if (o->op_private & OPpSORT_NUMERIC)
                sv_catpv(RETVAL, ",NUMERIC");
#endif
#ifdef OPpSORT_INTEGER
            if (o->op_private & OPpSORT_INTEGER)
                sv_catpv(RETVAL, ",INTEGER");
#endif
#ifdef OPpSORT_REVERSE
            if (o->op_private & OPpSORT_REVERSE)
                sv_catpv(RETVAL, ",REVERSE");
#endif
        }
#ifdef OPpDONE_SVREF
        else if (o->op_type == OP_THREADSV) {
            if (o->op_private & OPpDONE_SVREF)
                sv_catpv(RETVAL, ",SVREF");
        }
#endif
        else if (o->op_type == OP_OPEN || o->op_type == OP_BACKTICK) {
#ifdef OPpOPEN_IN_RAW
            if (o->op_private & OPpOPEN_IN_RAW)
                sv_catpv(RETVAL, ",IN_RAW");
#endif
#ifdef OPpOPEN_IN_CRLF
            if (o->op_private & OPpOPEN_IN_CRLF)
                sv_catpv(RETVAL, ",IN_CRLF");
#endif
#ifdef OPpOPEN_OUT_RAW
            if (o->op_private & OPpOPEN_OUT_RAW)
                sv_catpv(RETVAL, ",OUT_RAW");
#endif
#ifdef OPpOPEN_OUT_CRLF
            if (o->op_private & OPpOPEN_OUT_CRLF)
                sv_catpv(RETVAL, ",OUT_CRLF");
#endif
        }
#ifdef OPpEXIT_VMSISH
        else if (o->op_type == OP_EXIT) {
            if (o->op_private & OPpEXIT_VMSISH)
                sv_catpv(RETVAL, ",EXIST_VMSISH");
        }
#endif
#ifdef OPpLVAL_INTRO
        if (o->op_flags & OPf_MOD && o->op_private & OPpLVAL_INTRO)
            sv_catpv(RETVAL, ",INTRO");
#endif

        if (SvCUR(RETVAL))
            sv_chop(RETVAL, SvPVX(RETVAL)+1);
    OUTPUT:
        RETVAL

MODULE = B::Flags		PACKAGE = B::SV

SV*
flagspv(sv)
    B::SV sv
    U32 flags = NO_INIT
    U32 type  = NO_INIT
    CODE:
        RETVAL = newSVpvn("", 0);
        flags = SvFLAGS(sv);
        type = SvTYPE(sv);
        if (flags & SVs_PADBUSY)    sv_catpv(RETVAL, "PADBUSY,");
        if (flags & SVs_PADTMP)     sv_catpv(RETVAL, "PADTMP,");
        if (flags & SVs_PADMY)      sv_catpv(RETVAL, "PADMY,");
        if (flags & SVs_TEMP)       sv_catpv(RETVAL, "TEMP,");
        if (flags & SVs_OBJECT)     sv_catpv(RETVAL, "OBJECT,");
        if (flags & SVs_GMG)        sv_catpv(RETVAL, "GMG,");
        if (flags & SVs_SMG)        sv_catpv(RETVAL, "SMG,");
        if (flags & SVs_RMG)        sv_catpv(RETVAL, "RMG,");

        if (flags & SVf_IOK)        sv_catpv(RETVAL, "IOK,");
        if (flags & SVf_NOK)        sv_catpv(RETVAL, "NOK,");
        if (flags & SVf_POK)        sv_catpv(RETVAL, "POK,");
        if (flags & SVf_ROK)  {
                                    sv_catpv(RETVAL, "ROK,");
            if (SvWEAKREF(sv))      sv_catpv(RETVAL, "WEAKREF,");
        }
        if (flags & SVf_OOK)        sv_catpv(RETVAL, "OOK,");
        if (flags & SVf_FAKE)       sv_catpv(RETVAL, "FAKE,");
        if (flags & SVf_READONLY)   sv_catpv(RETVAL, "READONLY,");

        if (flags & SVf_AMAGIC)     sv_catpv(RETVAL, "OVERLOAD,");
        if (flags & SVp_IOK)        sv_catpv(RETVAL, "pIOK,");
        if (flags & SVp_NOK)        sv_catpv(RETVAL, "pNOK,");
        if (flags & SVp_POK)        sv_catpv(RETVAL, "pPOK,");
        if (flags & SVp_SCREAM)     sv_catpv(RETVAL, "SCREAM,");

        switch (type) {
        case SVt_PVCV:
        case SVt_PVFM:
            if (CvANON(sv))         sv_catpv(RETVAL, "ANON,");
            if (CvUNIQUE(sv))       sv_catpv(RETVAL, "UNIQUE,");
            if (CvCLONE(sv))        sv_catpv(RETVAL, "CLONE,");
            if (CvCLONED(sv))       sv_catpv(RETVAL, "CLONED,");
#ifdef CvCONST
            if (CvCONST(sv))        sv_catpv(RETVAL, "CONST,");
#endif
            if (CvNODEBUG(sv))      sv_catpv(RETVAL, "NODEBUG,");
            if (SvCOMPILED(sv))     sv_catpv(RETVAL, "COMPILED,");
            if (CvLVALUE(sv))       sv_catpv(RETVAL, "LVALUE,");
            if (CvMETHOD(sv))       sv_catpv(RETVAL, "METHOD,");
            break;
        case SVt_PVHV:
            if (HvSHAREKEYS(sv))    sv_catpv(RETVAL, "SHAREKEYS,");
            if (HvLAZYDEL(sv))      sv_catpv(RETVAL, "LAZYDEL,");
            break;
        case SVt_PVGV:
            if (GvINTRO(sv))        sv_catpv(RETVAL, "INTRO,");
            if (GvMULTI(sv))        sv_catpv(RETVAL, "MULTI,");
#ifdef GvSHARED
            if (GvSHARED(sv))       sv_catpv(RETVAL, "SHARED,");
#endif
            if (GvASSUMECV(sv))     sv_catpv(RETVAL, "ASSUMECV,");
            if (GvIN_PAD(sv))       sv_catpv(RETVAL, "IN_PAD,");
            if (GvIMPORTED(sv)) {
                sv_catpv(RETVAL, "IMPORT");
                if (GvIMPORTED(sv) == GVf_IMPORTED)
                    sv_catpv(RETVAL, "ALL,");
                else {
                    sv_catpv(RETVAL, "(");
                    if (GvIMPORTED_SV(sv))  sv_catpv(RETVAL, " SV");
                    if (GvIMPORTED_AV(sv))  sv_catpv(RETVAL, " AV");
                    if (GvIMPORTED_HV(sv))  sv_catpv(RETVAL, " HV");
                    if (GvIMPORTED_CV(sv))  sv_catpv(RETVAL, " CV");
                    sv_catpv(RETVAL, " ),");
                }
            }
            /* FALL THROUGH */
        default:
            if (SvEVALED(sv))       sv_catpv(RETVAL, "EVALED,");
            if (SvIsUV(sv))         sv_catpv(RETVAL, "IsUV,");
            if (SvUTF8(sv))         sv_catpv(RETVAL, "UTF8");
            break;
        case SVt_PVBM:
            if (SvTAIL(sv))         sv_catpv(RETVAL, "TAIL,");
            if (SvVALID(sv))        sv_catpv(RETVAL, "VALID,");
            break;
        }
        if (*(SvEND(RETVAL) - 1) == ',')
                SvPVX(RETVAL)[--SvCUR(RETVAL)] = '\0';
    OUTPUT:
        RETVAL
