package com.project.hunsu.model.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class WearMainDTO {
    private Boolean voteActivated;
    private Long wear_idx;
    private Long uid;
    private String nickname;
    private String title;
}
