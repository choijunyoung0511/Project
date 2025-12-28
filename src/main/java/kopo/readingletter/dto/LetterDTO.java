package kopo.readingletter.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class LetterDTO {
    private Long id;
    private Long userId;
    private Long bookId;
    private String content;
    private String tag;
    private Integer isPublic;   // 0/1
    private Integer likeCount;
    private Integer viewCount;
    private LocalDateTime createdAt;
    private String paperType;
    private String writingStyle;
    private Integer isAiGenerated; // tinyint → Integer 권장(혹은 boolean)
    private String aiPrompt; //프롬프트
}
