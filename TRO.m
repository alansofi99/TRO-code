function [BCostsFinal] = TRO(population_size, Max_iteration, lb, ub, dim, fobj)
    

    initial_driver_ratio = 0.4;  % Initial percentage of drivers

    for counter = 1:30
        
        positions = lb + (ub - lb) .* rand(population_size, dim);
        fitness = arrayfun(@(i) fobj(positions(i, :)), 1:population_size);

        % Select initial best drivers
        driver_ratio = initial_driver_ratio;
        driver_count = round(driver_ratio * population_size);
        [sorted_fitness, sorted_indices] = sort(fitness);
        driver_indices = sorted_indices(1:driver_count);
        driver_positions = positions(driver_indices, :);
        driver_leader_position = positions(sorted_indices(1), :);


        for iter = 1:Max_iteration
        
            % Compute average driver position
            average_driver_position = mean(driver_positions, 1);

            for i = 1:population_size
                % Select three random individuals
                r1 = randi([1 population_size]);
                r2 = randi([1 population_size]);
                r3 = randi([1 population_size]);
                % Ensure not duplication
                while r1 == i || r2 == i || r3 == i || ...
                      r1 == r2 || r1 == r3 || r2 == r3

                        r1 = randi([1 population_size]);
                        r2 = randi([1 population_size]);
                        r3 = randi([1 population_size]);

                end
 
                F= 0.7 + 0.8 * (iter / Max_iteration)^0.5;
                m_vector = positions(r1, :) + F *(positions(r2, :) - positions(r3, :));
                D = 0.8 * (1 - iter / Max_iteration);
                Ps=D * (m_vector - positions(i, :)); 
                P_adapt=0.1;
                
                if rand() > P_adapt

                a = rand();
                b = rand();
                
                trial_position = positions(i, :) + Ps...
                + a * (average_driver_position - positions(i, :))...
                + b * (driver_leader_position - positions(i, :));
                else
                        
                        self_weight = 0.95 * (1 - (iter / Max_iteration)^9);
                        adapt_coef = 2 - iter / Max_iteration;
                        local_rand = rand();
                        trial_position = self_weight * positions(i, :) + adapt_coef * local_rand * (average_driver_position - positions(i, :));
                end
                % Ensure positions remain within bounds
                trial_position = max(min(trial_position, ub), lb);

                % Evaluate new candidate
                trial_fitness = fobj(trial_position);
                if trial_fitness < fitness(i)
                    positions(i, :) = trial_position;
                    fitness(i) = trial_fitness;
                end
            end

            % Update driver leader and average driver position
            [sorted_fitness, sorted_indices] = sort(fitness);
            driver_indices = sorted_indices(1:driver_count);
            driver_positions = positions(driver_indices, :);
            driver_leader_fitness = sorted_fitness(1);
            driver_leader_position = positions(sorted_indices(1), :);

            % Store best fitness per iteration
            bestsolutions(iter) = driver_leader_fitness;
        end

        disp(['Run ' num2str(counter)  ', Best Cost = ' num2str(bestsolutions(iter))]);
        BCostsFinal(counter, :) = min(bestsolutions);
    end
  
end
