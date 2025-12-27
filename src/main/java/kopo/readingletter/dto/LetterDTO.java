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
}
