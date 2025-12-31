package kopo.readingletter.mapper;

import kopo.readingletter.dto.LetterDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LetterMapper {

    List<LetterDTO> selectMyLetters(@Param("userId") Long userId,
                                    @Param("scope") String scope);

    LetterDTO selectLetterDetail(@Param("id") Long id,
                                 @Param("userId") Long userId);

    int updateViewCount(@Param("id") Long id,
                        @Param("userId") Long userId);

    int insertLetter(LetterDTO dto);

    List<LetterDTO> selectLettersByScope(@Param("userId") Long userId,
                                         @Param("scope") String scope);

    List<String> selectDistinctTagsByUserId(Long userId);
}
