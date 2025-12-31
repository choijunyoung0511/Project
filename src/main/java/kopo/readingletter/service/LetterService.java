package kopo.readingletter.service;

import kopo.readingletter.dto.LetterDTO;
import kopo.readingletter.mapper.LetterMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LetterService {

    private final LetterMapper letterMapper;

    public List<LetterDTO> getMyLetters(Long userId, String scope) {
        return letterMapper.selectMyLetters(userId, scope);
    }

    public LetterDTO getLetterDetail(Long id, Long userId) {
        letterMapper.updateViewCount(id, userId);   // ✅ 조회수 +1
        return letterMapper.selectLetterDetail(id, userId);
    }

    public int insertLetter(LetterDTO dto) {
        return letterMapper.insertLetter(dto);
    }

    // ✅ 여기만 구현해주면 끝
    public List<String> getMyTags(Long userId) {
        return letterMapper.selectDistinctTagsByUserId(userId);
    }
}
