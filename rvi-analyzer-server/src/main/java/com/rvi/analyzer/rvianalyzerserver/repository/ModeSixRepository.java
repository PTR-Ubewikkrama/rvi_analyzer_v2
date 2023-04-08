package com.rvi.analyzer.rvianalyzerserver.repository;

import com.rvi.analyzer.rvianalyzerserver.entiy.ModeSix;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Mono;

public interface ModeSixRepository extends ReactiveMongoRepository<ModeSix, String> {
    @Query(
            value = """
    {
        "default-configurations.session-id" : {
            "$eq" : ?0
        }
    }
    """
    )
    Mono<ModeSix> findBySessionID(String sessionId);
}