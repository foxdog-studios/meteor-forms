%lex

%%

'£'      return 'CURRENCY';
\s+      /* Ignore white space */;
'+'      return 'POSITIVE';
'-'      return 'NEGATIVE';
[0]      return 'ZERO';
[1-9]    return 'NONEZERO';
','      return 'SEP';
'.'      return 'POINT';
<<EOF>>  return 'EOF';

/lex

%start currency_input

%%

currency_input
  : currency EOF
    { return $1; }
  ;

currency
  : normalized_amount
  | CURRENCY normalized_amount
    { $$ = $2; }
  ;

normalized_amount
  : signed_amount
    {
      if ($1.pounds == "0" && $1.pence == "") {
        $1.sign = "";
      }
    }
  ;

signed_amount
  : explicit_sign_amount
  | implicit_sign_amount
  ;

explicit_sign_amount
  : sign padded_amount
    {
      $2.sign = $1;
      $$ = $2;
    }
  ;

sign
  : POSITIVE
    { $$ = ""; }
  | NEGATIVE
    { $$ = "-"; }
  ;

implicit_sign_amount
  : padded_amount
    { $1.sign = ""; }
  ;

padded_amount
  : amount
    {
      if ($1.pounds.length == 0) {
        $1.pounds = "0";
      }
      while ($1.pence.length < 2) {
        $1.pence += "0";
      }
    }
  ;

amount
  : stripped_pounds
    { $$ = { pounds: $1, pence: "" }; }
  | point_pence
    { $$ = { pounds: "", pence: $1 }; }
  | stripped_pounds point_pence
    { $$ = { pounds: $1, pence: $2 }; }
  ;

stripped_pounds
  : pounds
  | leading_crufts
    { $$ = "0"; }
  | leading_crufts pounds
    { $$ = $2; }
  ;

leading_crufts
  : ZERO
  | ZERO crufts
  ;

pounds
  : NONEZERO
  | NONEZERO pounds_tail
    { $$ = $1 + $2; }
  ;

pounds_tail
  : pound
  | pound pounds_tail
    { $$ = $1 + $2; }
  ;

pound
  : SEP
    { $$ = ""; }
  | numeral
  ;


point_pence
  : POINT
    { $$ = ""; }
  | POINT pence_1
    { $$ = $2; }
  ;

pence_1
  : numeral
  | numeral pence_2
    { $$ = $1 + $2; }
  ;

pence_2
  : numeral
  | numeral zeros
  ;

crufts
  : cruft
  | cruft crufts
  ;

cruft
  : SEP
  | ZERO
  ;


numeral
  : ZERO
  | NONEZERO
  ;

zeros
  : ZERO
  | ZERO zeros
  ;

