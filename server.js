import express from 'express';
import fetch from 'node-fetch';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 4000;

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

app.post('/find-gamepasses', async (req, res) => {
    const nickname = req.body.nickname;

    try {
        // 1. Получаем userId по нику
        const userRes = await fetch(`https://users.roblox.com/v1/usernames/users`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ usernames: [nickname] })
        });

        const userData = await userRes.json();
        const userId = userData.data?.[0]?.id;
        console.log("👤 userId:", userId);
        if (!userId) return res.status(404).send('❌ Пользователь не найден');

        // 2. Получаем все placeId из публичных игр пользователя
        const gamesRes = await fetch(`https://games.roblox.com/v2/users/${userId}/games?accessFilter=Public&limit=50`);
        const gamesData = await gamesRes.json();

        if (!gamesData.data || !Array.isArray(gamesData.data)) {
            console.warn("⚠️ Нет игр:", gamesData);
            return res.status(404).send('❌ У пользователя нет публичных игр');
        }

        const placeIds = gamesData.data
            .map(game => game.rootPlace?.id)
            .filter(Boolean);

        if (!placeIds.length) return res.status(404).send('❌ Нет доступных плейсов');

        const allResults = [];
        let firstValidUniverseId = null;


        // 3. По каждому place → получаем universeId → геймпассы
        for (const placeId of placeIds) {
            try {
                const universeRes = await fetch(`https://apis.roblox.com/universes/v1/places/${placeId}/universe`);
                const universeJson = await universeRes.json();
                const universeId = universeJson.universeId;
                if (!universeId) continue;
                if (!firstValidUniverseId) firstValidUniverseId = universeId;

                const gpRes = await fetch(`https://games.roblox.com/v1/games/${universeId}/game-passes?limit=100&sortOrder=Asc`);
                const gpJson = await gpRes.json();

                if (!gpJson.data || !Array.isArray(gpJson.data)) continue;

                const filtered = gpJson.data
                    .filter(gp => gp.sellerId == userId && gp.price != null)
                    .map(gp =>
                        `https://www.roblox.com/game-pass/${gp.id} – ${gp.price}R$\nhttps://create.roblox.com/dashboard/creations/experiences/${universeId}/passes/${gp.id}/sales\n\n`
                    );


                allResults.push(...filtered);
            } catch (e) {
                console.warn(`⚠️ Ошибка обработки placeId ${placeId}:`, e.message);
            }
        }

        if (!allResults.length) {
            if (firstValidUniverseId) {
                const createLink = `https://create.roblox.com/dashboard/creations/experiences/${firstValidUniverseId}/passes/create`;
                return res.json({ result: [createLink] });
            }
            return res.json({ result: ['❌ Геймпассы не найдены'] });
        }

        res.json({ result: allResults });

    } catch (err) {
        console.error('❌ Ошибка:', err);
        res.status(500).send('⚠️ Ошибка сервера');
    }
});

app.listen(PORT, () => console.log(`🚀 Сервер запущен: http://localhost:${PORT}`));
