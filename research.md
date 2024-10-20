** Task Drscription **
Your task is to make and program a dune OCaml project using
the  [   Riot      ]  library,  for concurrency programming.

Try to provide a non-trivial application, not just a 'Hello, World'
program.

Try using the library to program data structures.

You must do some research and study, of course. If nothing else,
visit  the ecosystem at http://ocamlverse.net/, 
and https://opam.ocaml.org/packages/index-date.html.

** Riot Installation **
opam install riot
dune exec ./my_app.exe

** Using Riot **
[open Riot]: makes it so you don't have to prepend Riot functions with Riot.

[Riot.run @@ fun () -> function_name arg]
Riot programs always begin with a [Riot.run] call. This takes a function as an argument,
and runs forever. However, [Riot.shutdown] can be called to terminate the runtime.

[Riot.spawn]
This function creates a new process. Riot programs are able to run millions of processes
concurrently, and these processes are more similar to "green threads" or "fibers"
than traditional operating system processes/threads.
The function takes a [unit -> unit] function as input, and returns a [pid], which is a
process ID. Each PID in a program is unique, and can be used to interact with processes
while they are running.

[wait_pids [pid]]
This is similar to a traditional multithreading join() function, where the program waits for all
PIDs to terminate.

** Notes **
The Riot.run function can only accept one argument. This means that if I want to pass 2 elements to a multiprocessed Riot function (for example, a map function taking both a list and a function), I must send them as a tuple.