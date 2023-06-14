function join_by {
  local d=${1-} f=${2-}

  echo "${@/#/a}"
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}  

S=(a1 2 a4a 5 6)


# join_by , ${S[@]/a/b}

