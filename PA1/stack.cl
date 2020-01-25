(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class List inherits A2I {
   item: Int;
   next: List;

	item() : Int { item };
	next() : List { next };
   	push(i: Int, n: List) : List {
      {
         item <- i;
         next <- n;
         self;
      }
   	};
   	add() : Int {
		if (isvoid next) then
			{
				abort();
				0;
			}
		else
			{
				-- (new IO).out_string(i2a(item).concat("+").concat(i2a(next.item())).concat("\n"));
				item + next.item();
			}
		fi
   	};
   	mul() : Int {
		if (isvoid next) then
			{
				abort();
				0;
			}
		else
			{
				-- (new IO).out_string(i2a(item).concat("*").concat(i2a(next.item())).concat("\n"));
				item * next.item();
			}
		fi
   	};
};

class Main inherits IO {

   	main() : Object {
    	let nil: List,
        	stack: List <- (new List).push(0, nil),
			flag: Bool <- true,
			tmp: Int
		in
			while (flag) loop
				let c: String <- in_string() in
					if (c = "+") then
						{
							tmp <- stack.add();
							out_string((new A2I).i2a(tmp).concat("\n"));
							stack <- (new List).push(tmp, stack.next().next());
						}
					else
						if (c = "*") then
							{
								tmp <- stack.mul();
								out_string((new A2I).i2a(tmp).concat("\n"));
								stack <- (new List).push(tmp, stack.next().next());
							}
						else
							if (c = "x") then
								flag <- false
							else
								stack <- (new List).push((new A2I).a2i(c), stack)
							fi
						fi
					fi
			pool
   	};
};
