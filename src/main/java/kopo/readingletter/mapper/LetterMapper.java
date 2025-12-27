package kopo.readingletter.mapper;

import kopo.readingletter.dto.LetterDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LetterMapper {
    List<LetterDTO> selectMyLetters(@Param("userId") Long userId,
                                    @Param("scope") String scope);
    LetterDTO selectLetterDetail(Long id, Long userId);

    int updateViewCount(Long id, Long userId);
}
