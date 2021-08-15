
wtt := Object clone
wtt talk := method(
  "are you online? cll" println
  yield
  "have you off duty today" println
  yield
)

cll := Object clone
cll talk := method(
    yield
    "yes, here I am, wtt" println
    yield
    "I have a few minutes to off duty" println
)

wtt @@talk
cll @@talk

Coroutine currentCoroutine pause
