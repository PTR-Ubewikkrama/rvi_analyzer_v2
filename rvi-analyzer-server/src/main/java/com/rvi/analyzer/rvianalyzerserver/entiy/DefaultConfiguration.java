package com.rvi.analyzer.rvianalyzerserver.entiy;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "DefaultConfiguration")
public class DefaultConfiguration {
    @Id
    private Long _id;
    @Column
    private String customerName;
    @Column
    private String operatorId;
    @Column
    private String serialNo;
    @Column
    private String batchNo;
    @Column
    private String sessionId;
}
