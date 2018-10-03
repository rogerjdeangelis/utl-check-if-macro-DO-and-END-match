Do my %DOs and %ENDs match

github
https://github.com/rogerjdeangelis/utl-check-if-macro-DO-and-END-match

SAS  Forum
https://tinyurl.com/y93hkspl
https://communities.sas.com/t5/New-SAS-User/is-there-a-way-to-match-do-and-end-in-a-spaghetti-code/m-p/500965


macros  (download utl_perpac and include in your autoexec)
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

You need the original classic SAS editor for this
Two macros on end  or just include the performance package


INPUT
=====

  %do i=1 %to 10;
    %if &i=1 %then %do;
  %end;


EXAMPLE OUTPUT
--------------

**********************

Missing 1  %END

**********************


THREE WAYS TO RUN THE CHECK (ONLY WORKS IN OLD TEXT EDITOR)

SEE command macro doendh below

1. Highlight code and hit function key 'CNTL E'
2. Highlight and Hit Middle mouse button
3  Highlight and type doendh on command line


PROCESS
=======

FOR THE DO END SOLUTION (same for PARH)

Three techniques

1. put this on 'CNTL E'  store;note;notesubmit '%doendha';
2. Bring up you mouse application and map MMB to F1 and put note;notesubmit '%doendha;' on F1
3. You can place doend and doendh in autocall macro doend.sas

*
 _ __ ___   __ _  ___ _ __ ___  ___
| '_ ` _ \ / _` |/ __| '__/ _ \/ __|
| | | | | | (_| | (__| | | (_) \__ \
|_| |_| |_|\__,_|\___|_|  \___/|___/

;

* matching %do and %end;

%macro doendh / cmd;
   store;note;notesubmit '%doendha;';
   run;
%mend doendh;

%macro doendha;
   filename clp clipbrd ;
   data _null_;
     retain lft rgt 0 ;
     infile clp end=dne;
     do until(dne);
         input ;
         lft=lft+count(upcase(_infile_),'%DO ');
         lft=lft+count(upcase(_infile_),'%DO;');
         rgt=rgt+count(upcase(_infile_),'%END;');
         put lft= rgt=;
     end;
     lftrgt=lft - rgt;
     abslftrgt=abs(lftrgt);
     select;
        when (lftrgt=0) putlog "**********************" // '%DO %END  match'  // "**********************";
        when (lftrgt>0) putlog "**********************" // 'Missing ' lftrgt ' %END  '  // "**********************";
        when (lftrgt<0) putlog "**********************" // 'Missing ' abslftrgt  ' %DO;  '  // "**********************";
        otherwise;
     end;
   run;
%mend doendha;


* MATCHING PARENTHESE;


%macro parh / cmd
   des="highlight a line of code and type parh on the command line to test for unbalanced quotes";
   store;note;notesubmit '%parha;';
   run;
%mend parh;

%macro parha ;
   filename clp clipbrd ;
   data _null_;
     retain add 0;
     infile clp;
     input ;
     lft=countc(_infile_,'(');
     rgt=countc(_infile_,')');
     lftrgt=lft - rgt;
     abslftrgt=abs(lftrgt);
     select;
        when (lftrgt=0) putlog "**********************" // "Parentheses match  ()"  // "**********************";
        when (lftrgt>0) putlog "**********************" // "Missing " lftrgt ") parentheses  "  // "**********************";
        when (lftrgt<0) putlog "**********************" // "Missing " abslftrgt  "( parentheses  "  // "**********************";
        otherwise;
     end;
   run;
%mend parha;


