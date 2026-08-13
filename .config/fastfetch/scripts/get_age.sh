creation_ts=$(stat -c %W /)
now_ts=$(date +%s)

tot_days=$(((now_ts - creation_ts) / 86400))
years=$((tot_days / 365))
days=$((tot_days % 365))

years_plural=$([ "$years" -gt 1 ] && echo "s" || echo "")
days_plural=$([ "$days" -gt 1 ] && echo "s" || echo "")
echo "$years year${years_plural} $days day${days_plural}"
