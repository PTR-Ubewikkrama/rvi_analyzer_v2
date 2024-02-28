package com.rvi.analyzer.rvianalyzerserver.repository;

import com.rvi.analyzer.rvianalyzerserver.entiy.ModeSeven;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

@Repository
public class ModeSevenRepository {
    @Autowired
    ReactiveMongoTemplate template;

    public Flux<ModeSeven> findByFilters(Query query) {
        return template.find(query, ModeSeven.class);
    }

    public Mono<ModeSeven> findLatest(Query query) {
        return template.findOne(query, ModeSeven.class);
    }

    public Mono<Long> countByFilters(Query query) {
        return template.count(query, ModeSeven.class);
    }

    public Mono<ModeSeven> save(ModeSeven modeSeven) {
        return template.save(modeSeven);
    }

    public Mono<ModeSeven> findBySessionID(String sessionId) {
        Query query = new Query();
        query.addCriteria(Criteria.where("default-configurations.session-id").is(sessionId));
        return template.findOne(query, ModeSeven.class);
    }

    public Mono<Long> countSessionsByUsers(List<String> users) {
        Query query = new Query();
        query.addCriteria(Criteria.where("created-by").in(users));
        return template.count(query, ModeSeven.class);
    }

}