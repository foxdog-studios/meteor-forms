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
  | leading_zeros
  | leading_zeros pounds
    { $$ = $2; }
  ;

leading_zeros
  : ZERO
  | ZERO leading_zeros
  ;

pounds
  : pounds_1
  ;

pounds_1
  : NONEZERO
  | NONEZERO pounds_tail_groups
    { $$ = $1 + $2; }
  | NONEZERO pounds_2
    { $$ = $1 + $2; }
  ;

pounds_2
  : numeral
  | numeral pounds_tail_groups
    { $$ = $1 + $2; }
  | numeral pounds_3
    { $$ = $1 + $2; }
  ;

pounds_3
  : numeral
  | numeral pounds_tail_groups
    { $$ = $1 + $2; }
  | numeral pounds_tail_numerals
    { $$ = $1 + $2; }
  ;

pounds_tail_groups
  : pounds_tail_group
  | pounds_tail_group pounds_tail_groups
    { $$ = $1 + $2; }
  ;

pounds_tail_group
  : SEP three_numerals
    { $$ = $2; }
  ;

pounds_tail_numerals
  : numeral
  | numeral pounds_tail_numerals
    { $$ = $1 + $2; }
  ;


point_pence
  : POINT pence_1
    { $$ = $2; }
  ;

pence_1
  : numeral
  | numeral pence_2
    { $$ = $1 + $2; }
  ;

pence_2
  : numeral
  | numeral trailing_zeros
  ;

trailing_zeros
  : ZERO
  | ZERO trailing_zeros
  ;

three_numerals
  : numeral numeral numeral
    { $$ = $1 + $2 + $3; }
  ;

numeral
  : ZERO
  | NONEZERO
  ;

