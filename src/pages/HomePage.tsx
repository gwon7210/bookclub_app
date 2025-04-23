import React, { useEffect, useState } from 'react';
import axios from 'axios';

const API_BASE_URL = 'http://localhost:3000/api';

const HomePage: React.FC = () => {
  const [meetings, setMeetings] = useState([]);

  useEffect(() => {
    const fetchMeetings = async () => {
      try {
        const response = await axios.get(`${API_BASE_URL}/meetings`);
        setMeetings(response.data);
      } catch (error) {
        console.error('모임 목록을 불러오는데 실패했습니다:', error);
      }
    };

    // 초기 데이터 로드
    fetchMeetings();

    // 30초마다 데이터 갱신
    const intervalId = setInterval(fetchMeetings, 30000);

    // 컴포넌트 언마운트 시 인터벌 정리
    return () => clearInterval(intervalId);
  }, []);

  return (
    <div>
      {/* Render your component content here */}
    </div>
  );
};

export default HomePage; 