import * as React from 'react';
import {StyleSheet, View, Text, Button} from 'react-native';
import useColorsAwareObject from '../hooks/useColorsAwareObject';
import {Container} from '../components/Container';
import {
  LanguageType,
  type ColorsScheme,
} from '@aag-development/react-native-metaone-wallet-sdk';
import {useAppContext} from '../hooks/useApp';

const ChangeLanguageScreen: React.FC = () => {
  const {language, onChangeLanguage} = useAppContext();
  const styles = useColorsAwareObject(screenStyles);

  return (
    <Container>
      <View style={styles.head}>
        <Text style={styles.label}>Current Language: {language || ''}</Text>
      </View>
      <View style={styles.wrapper}>
        <Button
          onPress={() => onChangeLanguage(LanguageType.ENGLISH)}
          title="English"
        />
        <Button
          onPress={() => onChangeLanguage(LanguageType.INDONESIAN)}
          title="Indonesian"
        />
        <Button
          onPress={() => onChangeLanguage(LanguageType.FILIPINO)}
          title="Filipino"
        />
        <Button
          onPress={() => onChangeLanguage(LanguageType.VIETNAMESE)}
          title="Vietnamese"
        />
        <Button
          onPress={() => onChangeLanguage(LanguageType.INDONESIAN)}
          title="Indonesian"
        />
        <Button
          onPress={() => onChangeLanguage(LanguageType.CHINESE_SIMPLIFIED)}
          title="Chinese simplified"
        />
        <Button
          onPress={() => onChangeLanguage(LanguageType.CHINESE_TRADITIONAL)}
          title="Chinese traditional"
        />
      </View>
    </Container>
  );
};

const screenStyles = (colors: ColorsScheme) =>
  StyleSheet.create({
    label: {
      fontSize: 20,
      fontWeight: '700',
      color: colors.black,
      textAlign: 'center',
    },
    text: {
      color: colors.black,
    },
    head: {
      width: '100%',
      padding: 40,
    },
    wrapper: {
      flex: 1,
      width: '100%',
      gap: 15,
    },
  });

export default ChangeLanguageScreen;
