package com.rvi.analyzer.rvianalyzerserver.controller;


import com.rvi.analyzer.rvianalyzerserver.domain.CommonResponse;
import com.rvi.analyzer.rvianalyzerserver.dto.*;
import com.rvi.analyzer.rvianalyzerserver.service.SessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequiredArgsConstructor
public class SessionController {

    final private SessionService sessionService;

    @PostMapping(path = "/rvi/analyzer/v1/session/add/one")
    public Mono<CommonResponse> addModeOne(@RequestBody ModeOneDto modeOneDto){
        return sessionService.addModeOne(modeOneDto);
    }

    @PostMapping(path = "/rvi/analyzer/v1/session/add/two")
    public Mono<CommonResponse> addModeTwo(@RequestBody ModeTwoDto modeTwoDto){
        return sessionService.addModeTwo(modeTwoDto);
    }

    @PostMapping(path = "/rvi/analyzer/v1/session/add/three")
    public Mono<CommonResponse> addModeThree(@RequestBody ModeThreeDto modeThreeDto){
        return sessionService.addModeThree(modeThreeDto);
    }

    @PostMapping(path = "/rvi/analyzer/v1/session/add/four")
    public Mono<CommonResponse> addModeFour(@RequestBody ModeFourDto modeFourDto){
        return sessionService.addModeFour(modeFourDto);
    }
    @PostMapping(path = "/rvi/analyzer/v1/session/add/five")
    public Mono<CommonResponse> addModeFive(@RequestBody ModeFiveDto modeFiveDto){
        return sessionService.addModeFive(modeFiveDto);
    }

    @PostMapping(path = "/rvi/analyzer/v1/session/add/six")
    public Mono<CommonResponse> addModeFour(@RequestBody ModeSixDto modeSixDto){
        return sessionService.addModeSix(modeSixDto);
    }

}