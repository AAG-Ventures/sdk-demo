import * as React from 'react';
import {
    ActivityIndicator,
    StyleSheet,
    Text,
    TouchableOpacity,
    TouchableOpacityProps,
    View,
} from 'react-native';

import type { ColorsScheme } from '@aag-development/react-native-metaone-wallet-sdk';
import useColorsAwareObject from '../../hooks/useColorsAwareObject';

interface CustomButtonProps extends TouchableOpacityProps {
    label: string,
    loading?: boolean;
}
const CustomButton: React.FC<CustomButtonProps> = ({ loading = false, label, ...buttonProps }) => {
    const styles = useColorsAwareObject(screenStyles);
    return (
        <TouchableOpacity {...buttonProps}>
            <View style={styles.button}>
                <Text style={styles.buttonText}>
                    {loading && <ActivityIndicator size="small" color="white" />}
                    {!loading ? label : null}
                </Text>
            </View>
        </TouchableOpacity>
    );
};

const screenStyles = (colors: ColorsScheme) =>
    StyleSheet.create({
        button: {
            display: 'flex',
            flexDirection: 'row',
            justifyContent: 'space-evenly',
            alignItems: 'center',
            width: '100%',
            height: 30,
            backgroundColor: '#666',
        },
        buttonText: {
            color: '#fff',
            fontWeight: 'bold',
            fontSize: 15,
        },
    });
export default CustomButton;
