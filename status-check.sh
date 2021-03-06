echo "Net Asset Value:"
npm run get-nav | ./node_modules/.bin/bunyan
echo
echo "Running Services:"
npm run forever-list
echo
echo
echo "System uptime:"
uptime
echo
echo "Logs:"
tail siena.log | ./node_modules/.bin/bunyan
tail market-history-cache.log | ./node_modules/.bin/bunyan
echo
echo "Current UTC:"
date -u
market=$(ruby -rjson -e 'j = JSON.parse(File.read("config/default.json")); puts j["bittrexMarket"]')
echo
echo "Bittrex Cache Range:"
redis-cli ZRANGEBYSCORE $market -inf +inf LIMIT 0 1
redis-cli ZREVRANGEBYSCORE $market +inf -inf LIMIT 0 1
echo
echo "Last few crossovers:"
grep "crossover" siena.log | tail | ./node_modules/.bin/bunyan
echo
echo "Last Transaction:"
grep "for" siena.log | tail -1
echo
echo "Lower Sell Trigger Price:"
grep "Lower sell trigger" siena.log | tail -1 | ./node_modules/.bin/bunyan
echo
echo "Upper Sell Trigger Price:"
grep "Upper sell trigger" siena.log | tail -1 | ./node_modules/.bin/bunyan
HaltedTrade=$(cat siena.log | grep "Halt:" | ./node_modules/.bin/bunyan)
if [ ${#HaltedTrade} -gt 0 ]; then
  echo
  echo "Trading has been halted:"
  echo $HaltedTrade
  echo
fi
