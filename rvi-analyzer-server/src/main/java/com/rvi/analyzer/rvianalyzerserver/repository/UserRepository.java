package com.rvi.analyzer.rvianalyzerserver.repository;

import com.rvi.analyzer.rvianalyzerserver.entiy.User;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface UserRepository extends ReactiveMongoRepository<User, String> {
    Mono<User> findByUserName(String username);

    @Query(
            value = """
    {
        "username" : {
            $regex: .*?0.*
        }
    }
    """
    )
    Flux<User> findByUserNamePattern(String pattern);
}
