#!/bin/bash
input="perguntas.txt"
let i=1
let p=0
nivel="easy"
while IFS= read -r line
do
  string=$(echo "$line")
  if [[ $string == *"NIVEL "* ]]; then
    echo "$line"
    if [[ $string == *"FACIL"* ]]; then
      nivel="easy"
    fi
    if [[ $string == *"MEDIO"* ]]; then
      nivel="medium"
    fi
    if [[ $string == *"DIFICIL"* ]]; then
      nivel="hard"
    fi
  else
    if [[ $string == *"["* ]]; then
    let p++;
      echo $nivel > 'files/pergunta_'$p'.txt'

      echo "$line" > txt_line
      game=$(sed 's/\[//g' txt_line | cut -d ']' -f 1);
      question=$(sed 's/\[//g' txt_line | cut -d ']' -f 2);

      echo "$game" >> 'files/pergunta_'$p'.txt'
      echo "$question" >> 'files/pergunta_'$p'.txt'
    else
      echo "$line" >> 'files/pergunta_'$p'.txt'
    fi
  fi
  let i++
done < "$input"

echo "resposta_certa;nivel;jogo;pergunta;resposta_1;resposta_2;resposta_3;resposta_4;" > p_x.csv
search_dir="files"
for entry in "$search_dir"/*
do
  if [ -f "$entry" ];then
    sed 's/ X / x/g' "$entry" | sed 's/ X$/ x /g' | sed 's/ x / x/g' > txt_entry 
    numRes=$(grep -n " x$" txt_entry | cut -d ':' -f 1)
    res=$(grep -v "PERGUNTAS PARA TRÍVIA" $entry | awk '{printf "%s;", $0}')
  echo "$((10#$numRes-3));$res" >> p_x.csv
  rm "$entry"
  fi
done

sed 's/ x;/;/g' p_x.csv | grep -v "^;"> perguntas.csv
rm txt_entry
rm txt_line
rm p_x.csv