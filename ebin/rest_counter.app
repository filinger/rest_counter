{application,rest_counter,
             [{description,"REST Counter."},
              {vsn,"1"},
              {modules,[gen_counter,handler,rest_counter,rest_counter_app,
                        rest_counter_sup]},
              {registered,[]},
              {applications,[kernel,stdlib,cowboy]},
              {mod,{rest_counter_app,[]}},
              {env,[]}]}.
